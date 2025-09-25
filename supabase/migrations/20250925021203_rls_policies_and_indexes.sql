-- RLS Policies and Performance Indexes
-- Comprehensive security and performance improvements for the Shinobi MMO

-- ==============================================
-- TRANSACTIONS RLS POLICIES
-- ==============================================

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "transactions.select.self" ON transactions;
DROP POLICY IF EXISTS "transactions.write.service" ON transactions;
DROP POLICY IF EXISTS "Transactions read-only for clients" ON transactions;

-- READ: see your own ledger
CREATE POLICY "transactions.select.self"
ON transactions
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM players p
  WHERE p.id = transactions.actor_id
    AND p.user_id = auth.uid()
));

-- WRITE: only service_role creates ledger entries
CREATE POLICY "transactions.write.service"
ON transactions
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ==============================================
-- HOSPITAL STAYS RLS POLICIES
-- ==============================================

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "hospital_stays.select.self" ON hospital_stays;
DROP POLICY IF EXISTS "hospital_stays.write.service" ON hospital_stays;
DROP POLICY IF EXISTS "Hospital stays read-only for clients" ON hospital_stays;

-- READ: see your own hospital stays
CREATE POLICY "hospital_stays.select.self"
ON hospital_stays
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM players p
  WHERE p.id = hospital_stays.player_id
    AND p.user_id = auth.uid()
));

-- WRITE: only service_role manages hospital stays
CREATE POLICY "hospital_stays.write.service"
ON hospital_stays
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ==============================================
-- HEALS RLS POLICIES
-- ==============================================

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "heals.select.healer_or_target" ON heals;
DROP POLICY IF EXISTS "heals.write.service" ON heals;

-- READ: healer sees their actions; target sees actions on them
CREATE POLICY "heals.select.healer_or_target"
ON heals
FOR SELECT
TO authenticated
USING (
  EXISTS (SELECT 1 FROM players ph WHERE ph.id = heals.healer_id AND ph.user_id = auth.uid())
  OR
  EXISTS (SELECT 1 FROM players pt WHERE pt.id = heals.player_id AND pt.user_id = auth.uid())
);

-- WRITE: only service_role inserts (after validating same-village etc.)
CREATE POLICY "heals.write.service"
ON heals
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ==============================================
-- INVENTORY RLS POLICIES
-- ==============================================

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "player_items.select.self" ON player_items;
DROP POLICY IF EXISTS "player_items.write.service" ON player_items;
DROP POLICY IF EXISTS "equipped_items.select.self" ON equipped_items;
DROP POLICY IF EXISTS "equipped_items.write.service" ON equipped_items;

-- READ: owner reads their inventory
CREATE POLICY "player_items.select.self"
ON player_items
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM players p WHERE p.id = player_items.player_id AND p.user_id = auth.uid()
));

CREATE POLICY "equipped_items.select.self"
ON equipped_items
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM players p WHERE p.id = equipped_items.player_id AND p.user_id = auth.uid()
));

-- WRITE: only service_role mutates (equip/unequip/craft via Edge Functions)
CREATE POLICY "player_items.write.service"
ON player_items
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

CREATE POLICY "equipped_items.write.service"
ON equipped_items
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ==============================================
-- JUTSU COOLDOWNS RLS POLICIES
-- ==============================================

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "jutsu_cooldowns.select.self" ON jutsu_cooldowns;
DROP POLICY IF EXISTS "jutsu_cooldowns.write.service" ON jutsu_cooldowns;

-- READ: owner reads their jutsu cooldowns
CREATE POLICY "jutsu_cooldowns.select.self"
ON jutsu_cooldowns
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM players p WHERE p.id = jutsu_cooldowns.player_id AND p.user_id = auth.uid()
));

-- WRITE: only service_role manages jutsu cooldowns
CREATE POLICY "jutsu_cooldowns.write.service"
ON jutsu_cooldowns
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ==============================================
-- BATTLE SYSTEM RLS POLICIES
-- ==============================================

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "battles.select.participant" ON battles;
DROP POLICY IF EXISTS "battles.write.service" ON battles;
DROP POLICY IF EXISTS "battle_participants.select.self_battles" ON battle_participants;
DROP POLICY IF EXISTS "battle_participants.write.service" ON battle_participants;
DROP POLICY IF EXISTS "battle_positions.select.participant" ON battle_positions;
DROP POLICY IF EXISTS "battle_positions.write.service" ON battle_positions;
DROP POLICY IF EXISTS "battle_actions.select.participant" ON battle_actions;
DROP POLICY IF EXISTS "battle_actions.write.service" ON battle_actions;

-- READ: participants can read battle rows
CREATE POLICY "battles.select.participant"
ON battles
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM battle_participants bp
  JOIN players p ON p.id = bp.player_id
  WHERE bp.battle_id = battles.id
    AND p.user_id = auth.uid()
));

CREATE POLICY "battle_participants.select.self_battles"
ON battle_participants
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM players p WHERE p.id = battle_participants.player_id AND p.user_id = auth.uid()
));

CREATE POLICY "battle_positions.select.participant"
ON battle_positions
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM battle_participants bp
  JOIN players p ON p.id = bp.player_id
  WHERE bp.battle_id = battle_positions.battle_id
    AND p.user_id = auth.uid()
));

CREATE POLICY "battle_actions.select.participant"
ON battle_actions
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM battle_participants bp
  JOIN players p ON p.id = bp.player_id
  WHERE bp.battle_id = battle_actions.battle_id
    AND p.user_id = auth.uid()
));

-- WRITE: only service_role writes (authoritative server)
CREATE POLICY "battles.write.service" ON battles FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "battle_participants.write.service" ON battle_participants FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "battle_positions.write.service" ON battle_positions FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "battle_actions.write.service" ON battle_actions FOR ALL TO service_role USING (true) WITH CHECK (true);

-- ==============================================
-- INTEREST OFFERS RLS POLICIES
-- ==============================================

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "interest_offers.select.self" ON interest_offers;
DROP POLICY IF EXISTS "interest_offers.write.service" ON interest_offers;

-- READ: users see their own interest offers
CREATE POLICY "interest_offers.select.self"
ON interest_offers
FOR SELECT
TO authenticated
USING ( EXISTS (
  SELECT 1 FROM players p WHERE p.id = interest_offers.player_id AND p.user_id = auth.uid()
));

-- WRITE: only service_role manages interest offers
CREATE POLICY "interest_offers.write.service"
ON interest_offers
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ==============================================
-- NOTE: LEADERBOARDS RLS POLICIES
-- ==============================================

-- leaderboards is a materialized view and doesn't support RLS policies directly
-- Security is handled by the underlying tables (players, player_progress) which have RLS enabled

-- ==============================================
-- PERFORMANCE INDEXES
-- ==============================================

-- Hospital system: find players waiting for treatment
CREATE INDEX IF NOT EXISTS idx_hospital_waiting
  ON hospital_stays (player_id)
  WHERE status = 'waiting';

-- Transactions: find recent transactions by actor
CREATE INDEX IF NOT EXISTS idx_transactions_actor_time
  ON transactions (actor_id, created_at DESC);

-- Battle system: find actions by battle and time
CREATE INDEX IF NOT EXISTS idx_battle_actions_battle_time
  ON battle_actions (battle_id, created_at);

-- Player stats: find damaged players
CREATE INDEX IF NOT EXISTS idx_player_stats_damaged
  ON player_stats (player_id)
  WHERE hp < hp_max;
