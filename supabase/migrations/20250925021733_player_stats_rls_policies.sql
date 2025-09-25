-- RLS Policies for player_stats table
-- Implements secure access control for player statistics data

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "player_stats.select.self" ON player_stats;
DROP POLICY IF EXISTS "player_stats.write.service" ON player_stats;
DROP POLICY IF EXISTS "Players can view own stats" ON player_stats;
DROP POLICY IF EXISTS "Player stats read-only for clients" ON player_stats;

-- READ: a user can see only their own player stats
CREATE POLICY "player_stats.select.self"
ON player_stats
FOR SELECT
TO authenticated
USING ( EXISTS (SELECT 1 FROM players p WHERE p.id = player_stats.player_id AND p.user_id = auth.uid()) );

-- WRITE: only service_role (Edge Functions) may insert/update/delete
CREATE POLICY "player_stats.write.service"
ON player_stats
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);
