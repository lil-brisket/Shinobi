-- Shinobi MMO Database Schema
-- Comprehensive schema for Flutter MMO with all modules

-- Enable necessary extensions (uuid-ossp not needed, using gen_random_uuid())

-- ==============================================
-- ENUM TYPES
-- ==============================================

-- Item slot types (only create if they don't exist)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'item_slot') THEN
    CREATE TYPE item_slot AS ENUM (
        'head',
        'chest', 
        'legs',
        'feet',
        'weapon',
        'accessory'
    );
  END IF;
END $$;

-- Clan member roles already exist from 002_clan_system.sql
-- Using existing values: 'LEADER', 'ADVISOR', 'MEMBER'

-- Hospital stay status (only create if it doesn't exist)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'hospital_status') THEN
    CREATE TYPE hospital_status AS ENUM (
        'waiting',
        'treating',
        'discharged'
    );
  END IF;
END $$;

-- Chat channels (only create if it doesn't exist)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'chat_channel') THEN
    CREATE TYPE chat_channel AS ENUM (
        'global',
        'clan'
    );
  END IF;
END $$;

-- Battle status (only create if it doesn't exist)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'battle_status') THEN
    CREATE TYPE battle_status AS ENUM (
        'active',
        'completed',
        'cancelled'
    );
  END IF;
END $$;

-- Notification status (only create if it doesn't exist)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'notification_status') THEN
    CREATE TYPE notification_status AS ENUM (
        'unread',
        'read',
        'archived'
    );
  END IF;
END $$;

-- ==============================================
-- IDENTITY/CORE MODULE
-- ==============================================

-- Villages table (may already exist from previous migrations)
CREATE TABLE IF NOT EXISTS villages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    coordinates POINT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Players table (may already exist from previous migrations - will extend it)
CREATE TABLE IF NOT EXISTS players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username VARCHAR(50) NOT NULL UNIQUE,
    village_id UUID NOT NULL REFERENCES villages(id) ON DELETE RESTRICT,
    location VARCHAR(100) DEFAULT 'village_center',
    money INTEGER DEFAULT 0 CHECK (money >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add columns to existing players table if they don't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'players' AND column_name = 'village_id') THEN
    ALTER TABLE players ADD COLUMN village_id UUID REFERENCES villages(id) ON DELETE RESTRICT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'players' AND column_name = 'location') THEN
    ALTER TABLE players ADD COLUMN location VARCHAR(100) DEFAULT 'village_center';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'players' AND column_name = 'money') THEN
    ALTER TABLE players ADD COLUMN money INTEGER DEFAULT 0 CHECK (money >= 0);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'players' AND column_name = 'user_id') THEN
    ALTER TABLE players ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- ==============================================
-- STATS/PROGRESSION MODULE
-- ==============================================

-- Player stats table
CREATE TABLE IF NOT EXISTS player_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    hp INTEGER NOT NULL DEFAULT 100 CHECK (hp >= 0),
    hp_max INTEGER NOT NULL DEFAULT 100 CHECK (hp_max > 0 AND hp <= hp_max),
    cp INTEGER NOT NULL DEFAULT 100 CHECK (cp >= 0),
    cp_max INTEGER NOT NULL DEFAULT 100 CHECK (cp_max > 0 AND cp <= cp_max),
    sp INTEGER NOT NULL DEFAULT 100 CHECK (sp >= 0),
    sp_max INTEGER NOT NULL DEFAULT 100 CHECK (sp_max > 0 AND sp <= sp_max),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id)
);

-- Player progress table
CREATE TABLE IF NOT EXISTS player_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    level INTEGER NOT NULL DEFAULT 1 CHECK (level >= 1 AND level <= 100),
    xp INTEGER NOT NULL DEFAULT 0 CHECK (xp >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id)
);

-- Professions table
CREATE TABLE IF NOT EXISTS professions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    medical_xp INTEGER DEFAULT 0 CHECK (medical_xp >= 0),
    medical_rank INTEGER DEFAULT 0 CHECK (medical_rank >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id)
);

-- ==============================================
-- CLANS MODULE
-- ==============================================

-- Clans table (already exists from 002_clan_system.sql)
-- Skip creating - it already exists with different structure

-- Clan members table (already exists from 002_clan_system.sql)
-- Skip creating - it already exists with different structure

-- Clan messages table
CREATE TABLE IF NOT EXISTS clan_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clan_id UUID NOT NULL REFERENCES clans(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clan requests table
CREATE TABLE IF NOT EXISTS clan_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clan_id UUID NOT NULL REFERENCES clans(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(clan_id, player_id)
);

-- ==============================================
-- ECONOMY MODULE
-- ==============================================

-- Transactions table (already exists from 001_banking_system.sql)
-- Skip creating - it already exists with different structure

-- Wallets table (already exists from 001_banking_system.sql)
-- Skip creating - it already exists with different structure

-- ==============================================
-- INVENTORY MODULE
-- ==============================================

-- Items table
CREATE TABLE IF NOT EXISTS items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    slot item_slot,
    stats JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Player items table
CREATE TABLE IF NOT EXISTS player_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Equipped items table
CREATE TABLE IF NOT EXISTS equipped_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    slot item_slot NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id, slot)
);

-- Crafting recipes table
CREATE TABLE IF NOT EXISTS crafting_recipes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    result_item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    components JSONB NOT NULL,
    skill_required VARCHAR(50),
    level_required INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================
-- JUTSU MODULE
-- ==============================================

-- Jutsu table
CREATE TABLE IF NOT EXISTS jutsu (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    element VARCHAR(50),
    power INTEGER DEFAULT 0 CHECK (power >= 0),
    chakra_cost INTEGER DEFAULT 0 CHECK (chakra_cost >= 0),
    cooldown_seconds INTEGER DEFAULT 0 CHECK (cooldown_seconds >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Jutsu effects table
CREATE TABLE IF NOT EXISTS jutsu_effects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    jutsu_id UUID NOT NULL REFERENCES jutsu(id) ON DELETE CASCADE,
    effect_type VARCHAR(50) NOT NULL,
    effect_value INTEGER,
    duration_seconds INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Player jutsu table
CREATE TABLE IF NOT EXISTS player_jutsu (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    jutsu_id UUID NOT NULL REFERENCES jutsu(id) ON DELETE CASCADE,
    learned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id, jutsu_id)
);

-- Jutsu cooldowns table
CREATE TABLE IF NOT EXISTS jutsu_cooldowns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    jutsu_id UUID NOT NULL REFERENCES jutsu(id) ON DELETE CASCADE,
    usable_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================
-- COMBAT MODULE
-- ==============================================

-- Battles table
CREATE TABLE IF NOT EXISTS battles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    status battle_status DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Battle participants table
CREATE TABLE IF NOT EXISTS battle_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    battle_id UUID NOT NULL REFERENCES battles(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    team VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(battle_id, player_id)
);

-- Battle turns table
CREATE TABLE IF NOT EXISTS battle_turns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    battle_id UUID NOT NULL REFERENCES battles(id) ON DELETE CASCADE,
    turn_number INTEGER NOT NULL CHECK (turn_number > 0),
    current_player_id UUID REFERENCES players(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Battle actions table
CREATE TABLE IF NOT EXISTS battle_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    battle_id UUID NOT NULL REFERENCES battles(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    action_type VARCHAR(50) NOT NULL,
    payload JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Battle positions table
CREATE TABLE IF NOT EXISTS battle_positions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    battle_id UUID NOT NULL REFERENCES battles(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    position_x INTEGER NOT NULL,
    position_y INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(battle_id, player_id)
);

-- ==============================================
-- HOSPITAL MODULE
-- ==============================================

-- Hospital stays table
CREATE TABLE IF NOT EXISTS hospital_stays (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    status hospital_status DEFAULT 'waiting',
    estimated_heal_time INTEGER, -- minutes
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id)
);

-- Heals table
CREATE TABLE IF NOT EXISTS heals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    healer_id UUID REFERENCES players(id) ON DELETE SET NULL,
    amount_healed INTEGER NOT NULL CHECK (amount_healed > 0),
    cost INTEGER DEFAULT 0 CHECK (cost >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================
-- WORLD MODULE
-- ==============================================

-- Tiles table
CREATE TABLE IF NOT EXISTS tiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    tile_type VARCHAR(50) NOT NULL,
    properties JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(x, y)
);

-- Player positions table
CREATE TABLE IF NOT EXISTS player_positions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id)
);

-- Travel logs table
CREATE TABLE IF NOT EXISTS travel_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    from_x INTEGER NOT NULL,
    from_y INTEGER NOT NULL,
    to_x INTEGER NOT NULL,
    to_y INTEGER NOT NULL,
    travel_time_seconds INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================
-- SOCIAL MODULE
-- ==============================================

-- Chat messages table
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    channel chat_channel NOT NULL,
    clan_id UUID REFERENCES clans(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Mail table
CREATE TABLE IF NOT EXISTS mail (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES players(id) ON DELETE SET NULL,
    recipient_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    subject VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status notification_status DEFAULT 'unread',
    type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================
-- ADMIN MODULE
-- ==============================================

-- Audit log table
CREATE TABLE IF NOT EXISTS audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID REFERENCES players(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Feature flags table
CREATE TABLE IF NOT EXISTS feature_flags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    is_enabled BOOLEAN DEFAULT FALSE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================
-- PARTIAL UNIQUE INDEXES
-- ==============================================

-- Hospital stays: unique waiting per player
CREATE UNIQUE INDEX IF NOT EXISTS hospital_stays_unique_waiting 
ON hospital_stays (player_id) 
WHERE status = 'waiting';

-- Player stats: for injured players
CREATE INDEX IF NOT EXISTS player_stats_injured 
ON player_stats (player_id) 
WHERE hp < hp_max;

-- Transactions: recent transactions by player (using existing columns)
CREATE INDEX IF NOT EXISTS transactions_actor_recent 
ON transactions (actor_id, created_at DESC);
CREATE INDEX IF NOT EXISTS transactions_sender_recent 
ON transactions (sender_id, created_at DESC);
CREATE INDEX IF NOT EXISTS transactions_receiver_recent 
ON transactions (receiver_id, created_at DESC);

-- Battle actions: by battle and time
CREATE INDEX IF NOT EXISTS battle_actions_battle_time 
ON battle_actions (battle_id, created_at);

-- ==============================================
-- MATERIALIZED VIEW STUBS
-- ==============================================

-- Leaderboards materialized view (empty stub)
CREATE MATERIALIZED VIEW IF NOT EXISTS leaderboards AS
SELECT 
    p.id as player_id,
    p.username,
    pp.level,
    pp.xp
FROM players p
LEFT JOIN player_progress pp ON p.id = pp.player_id
WHERE 1=0; -- Empty stub

-- ==============================================
-- ROW LEVEL SECURITY (RLS)
-- ==============================================

-- Enable RLS on all tables
ALTER TABLE villages ENABLE ROW LEVEL SECURITY;
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE professions ENABLE ROW LEVEL SECURITY;
ALTER TABLE clans ENABLE ROW LEVEL SECURITY;
ALTER TABLE clan_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE clan_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE clan_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipped_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE crafting_recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE jutsu ENABLE ROW LEVEL SECURITY;
ALTER TABLE jutsu_effects ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_jutsu ENABLE ROW LEVEL SECURITY;
ALTER TABLE jutsu_cooldowns ENABLE ROW LEVEL SECURITY;
ALTER TABLE battles ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_turns ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE hospital_stays ENABLE ROW LEVEL SECURITY;
ALTER TABLE heals ENABLE ROW LEVEL SECURITY;
ALTER TABLE tiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE travel_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE mail ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;

-- ==============================================
-- EXAMPLE RLS POLICIES
-- ==============================================

-- Players can select their own rows
DROP POLICY IF EXISTS "Players can view own data" ON players;
CREATE POLICY "Players can view own data" ON players
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Players can view own stats" ON player_stats;
CREATE POLICY "Players can view own stats" ON player_stats
    FOR SELECT USING (auth.uid() = (SELECT user_id FROM players WHERE id = player_id));

-- Sensitive tables: read-only for clients, service_role can write
DROP POLICY IF EXISTS "Player stats read-only for clients" ON player_stats;
CREATE POLICY "Player stats read-only for clients" ON player_stats
    FOR SELECT USING (auth.uid() = (SELECT user_id FROM players WHERE id = player_id));

DROP POLICY IF EXISTS "Wallets read-only for clients" ON wallets;
CREATE POLICY "Wallets read-only for clients" ON wallets
    FOR SELECT USING (auth.uid() = (SELECT user_id FROM players WHERE id = player_id));

DROP POLICY IF EXISTS "Transactions read-only for clients" ON transactions;
CREATE POLICY "Transactions read-only for clients" ON transactions
    FOR SELECT USING (auth.uid() = (SELECT user_id FROM players WHERE id = actor_id OR id = sender_id OR id = receiver_id));

DROP POLICY IF EXISTS "Hospital stays read-only for clients" ON hospital_stays;
CREATE POLICY "Hospital stays read-only for clients" ON hospital_stays
    FOR SELECT USING (auth.uid() = (SELECT user_id FROM players WHERE id = player_id));

-- Clan content readable by members only
DROP POLICY IF EXISTS "Clan members can view clan data" ON clans;
CREATE POLICY "Clan members can view clan data" ON clans
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM clan_members cm 
            WHERE cm.clan_id = clans.id AND cm.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Clan members can view clan messages" ON clan_messages;
CREATE POLICY "Clan members can view clan messages" ON clan_messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM clan_members cm 
            WHERE cm.clan_id = clan_messages.clan_id AND cm.user_id = auth.uid()
        )
    );

-- Chat: global readable by all; clan readable by clan members
DROP POLICY IF EXISTS "Global chat readable by all" ON chat_messages;
CREATE POLICY "Global chat readable by all" ON chat_messages
    FOR SELECT USING (channel = 'global');

DROP POLICY IF EXISTS "Clan chat readable by clan members" ON chat_messages;
CREATE POLICY "Clan chat readable by clan members" ON chat_messages
    FOR SELECT USING (
        channel = 'clan' AND 
        EXISTS (
            SELECT 1 FROM clan_members cm 
            WHERE cm.clan_id = chat_messages.clan_id AND cm.user_id = auth.uid()
        )
    );

-- Public tables (readable by all authenticated users)
DROP POLICY IF EXISTS "Villages public read" ON villages;
CREATE POLICY "Villages public read" ON villages FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Items public read" ON items;
CREATE POLICY "Items public read" ON items FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Jutsu public read" ON jutsu;
CREATE POLICY "Jutsu public read" ON jutsu FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS "Crafting recipes public read" ON crafting_recipes;
CREATE POLICY "Crafting recipes public read" ON crafting_recipes FOR SELECT USING (auth.role() = 'authenticated');

-- Admin tables (service_role only)
DROP POLICY IF EXISTS "Audit log service role only" ON audit_log;
CREATE POLICY "Audit log service role only" ON audit_log FOR ALL USING (auth.role() = 'service_role');
DROP POLICY IF EXISTS "Feature flags service role only" ON feature_flags;
CREATE POLICY "Feature flags service role only" ON feature_flags FOR ALL USING (auth.role() = 'service_role');

-- ==============================================
-- INITIAL DATA
-- ==============================================

-- Insert default villages (using existing table structure)
-- Note: Villages already exist from previous migrations, skipping insertion

-- Insert some basic items
INSERT INTO items (name, description, slot, stats) VALUES
('Basic Kunai', 'A simple throwing knife', 'weapon', '{"damage": 10, "range": 5}'),
('Headband', 'A ninja headband', 'head', '{"defense": 2, "chakra": 5}'),
('Training Clothes', 'Basic training outfit', 'chest', '{"defense": 5, "mobility": 3}'),
('Ninja Sandals', 'Lightweight footwear', 'feet', '{"speed": 5, "stealth": 3}');

-- Insert some basic jutsu
INSERT INTO jutsu (name, description, element, power, chakra_cost, cooldown_seconds) VALUES
('Kunai Throw', 'Basic projectile attack', 'none', 15, 5, 2),
('Chakra Enhancement', 'Boost physical abilities', 'none', 0, 10, 10),
('Fireball Jutsu', 'Create a fire projectile', 'fire', 25, 15, 5),
('Water Bullet', 'Compressed water attack', 'water', 20, 12, 4);

-- Insert feature flags
INSERT INTO feature_flags (name, is_enabled, description) VALUES
('clan_system', true, 'Enable clan functionality'),
('hospital_system', true, 'Enable hospital healing system'),
('battle_system', true, 'Enable combat system'),
('chat_system', true, 'Enable global and clan chat'),
('mail_system', true, 'Enable mail system'),
('notifications', true, 'Enable notification system');
