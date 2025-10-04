-- Kage MMORPG Database Schema
-- This file contains the complete database schema for the Kage MMORPG

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Villages table
CREATE TABLE villages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  element TEXT CHECK (element IN ('fire', 'water', 'earth', 'wind', 'lightning', 'ice', 'lava', 'magnet', 'boil', 'storm', 'crystal', 'wood', 'steam', 'explosion', 'dark', 'light', 'void', 'nature', 'metal', 'dust')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default villages
INSERT INTO villages (id, name, description, element) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'Willowshade Village', 'A peaceful village known for its healing techniques', 'nature'),
  ('550e8400-e29b-41d4-a716-446655440002', 'Firestorm Village', 'A village of warriors specializing in fire techniques', 'fire'),
  ('550e8400-e29b-41d4-a716-446655440003', 'Deepwater Village', 'A village hidden in the mist, masters of water', 'water'),
  ('550e8400-e29b-41d4-a716-446655440004', 'Iron Mountain Village', 'A village built into the mountains, earth specialists', 'earth'),
  ('550e8400-e29b-41d4-a716-446655440005', 'Skywind Village', 'A floating village of wind masters', 'wind');

-- Players table
CREATE TABLE players (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL,
  avatar_url TEXT,
  village_id UUID REFERENCES villages(id) NOT NULL,
  ryo INTEGER DEFAULT 500 CHECK (ryo >= 0), -- Starting pocket money
  
  -- Core stats (max 250k each) - minimal starting values
  level INTEGER DEFAULT 1 CHECK (level >= 1),
  str INTEGER DEFAULT 100 CHECK (str >= 0 AND str <= 250000),
  intl INTEGER DEFAULT 100 CHECK (intl >= 0 AND intl <= 250000),
  spd INTEGER DEFAULT 100 CHECK (spd >= 0 AND spd <= 250000),
  wil INTEGER DEFAULT 100 CHECK (wil >= 0 AND wil <= 250000),
  
  -- Combat stats (max 500k each) - minimal starting values
  nin INTEGER DEFAULT 100 CHECK (nin >= 0 AND nin <= 500000),
  gen INTEGER DEFAULT 100 CHECK (gen >= 0 AND gen <= 500000),
  buk INTEGER DEFAULT 100 CHECK (buk >= 0 AND buk <= 500000),
  tai INTEGER DEFAULT 100 CHECK (tai >= 0 AND tai <= 500000),
  
  -- Current HP/SP/CP
  current_hp INTEGER DEFAULT 600 CHECK (current_hp >= 0),
  current_sp INTEGER DEFAULT 600 CHECK (current_sp >= 0),
  current_cp INTEGER DEFAULT 600 CHECK (current_cp >= 0),
  
  -- Player rank
  rank TEXT DEFAULT 'genin' CHECK (rank IN ('genin', 'chunin', 'jonin', 'anbu', 'kage')),
  
  -- Medical ninja profession
  med_ninja_level INTEGER DEFAULT 1 CHECK (med_ninja_level >= 1),
  med_ninja_xp INTEGER DEFAULT 0 CHECK (med_ninja_xp >= 0),
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Items table (master list of all items)
CREATE TABLE items (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  rarity TEXT CHECK (rarity IN ('common', 'uncommon', 'rare', 'epic', 'legendary', 'mythic')),
  effect JSONB,
  kind TEXT CHECK (kind IN ('material', 'consumable', 'equipment', 'special')),
  size TEXT CHECK (size IN ('small', 'medium', 'large')),
  max_stack INTEGER DEFAULT 1 CHECK (max_stack >= 1),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default items
INSERT INTO items (id, name, description, icon, rarity, effect, kind, size, max_stack) VALUES
  ('kunai', 'Kunai', 'A versatile throwing weapon', '🗡️', 'common', '{"damage": 25}', 'material', 'small', 99),
  ('shuriken', 'Shuriken', 'Sharp throwing star', '⭐', 'common', '{"damage": 20}', 'material', 'small', 99),
  ('health_potion', 'Health Potion', 'Restores HP', '🧪', 'uncommon', '{"heal": 100}', 'consumable', 'small', 50),
  ('chakra_potion', 'Chakra Potion', 'Restores CP', '💙', 'uncommon', '{"chakra_heal": 100}', 'consumable', 'small', 50),
  ('stamina_potion', 'Stamina Potion', 'Restores SP', '❤️', 'uncommon', '{"stamina_heal": 100}', 'consumable', 'small', 50);

-- Jutsus table (master list of all jutsus)
CREATE TABLE jutsus (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT CHECK (type IN ('ninjutsu', 'genjutsu', 'taijutsu', 'bukijutsu')),
  chakra_cost INTEGER DEFAULT 0 CHECK (chakra_cost >= 0),
  stamina_cost INTEGER DEFAULT 0 CHECK (stamina_cost >= 0),
  power INTEGER DEFAULT 0 CHECK (power >= 0),
  description TEXT,
  range INTEGER DEFAULT 1 CHECK (range >= 1),
  targeting TEXT CHECK (targeting IN ('single_target', 'area_of_effect', 'straight_line', 'movement_ability', 'self_buff', 'heal')),
  area_radius INTEGER DEFAULT 0 CHECK (area_radius >= 0),
  ap_cost INTEGER DEFAULT 20 CHECK (ap_cost >= 0),
  cooldown INTEGER DEFAULT 0 CHECK (cooldown >= 0),
  element TEXT CHECK (element IN ('fire', 'water', 'earth', 'wind', 'lightning', 'ice', 'lava', 'magnet', 'boil', 'storm', 'crystal', 'wood', 'steam', 'explosion', 'dark', 'light', 'void', 'nature', 'metal', 'dust', 'none')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default jutsus
INSERT INTO jutsus (id, name, type, chakra_cost, power, description, range, targeting, ap_cost, element) VALUES
  ('basic_punch', 'Basic Punch', 'taijutsu', 0, 50, 'A basic melee attack', 1, 'single_target', 20, 'none'),
  ('basic_heal', 'Basic Heal', 'ninjutsu', 40, 100, 'Restores HP to target', 2, 'single_target', 30, 'nature'),
  ('rasengan', 'Rasengan', 'ninjutsu', 80, 450, 'A powerful spinning chakra attack in a straight line', 4, 'straight_line', 60, 'wind'),
  ('shadow_clone', 'Shadow Clone Jutsu', 'ninjutsu', 60, 300, 'Teleport and damage enemies around you', 3, 'movement_ability', 60, 'none'),
  ('wind_style', 'Wind Style: Great Breakthrough', 'ninjutsu', 100, 380, 'Powerful wind attack', 2, 'single_target', 40, 'wind');

-- Player items table (inventory)
CREATE TABLE player_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  item_id TEXT REFERENCES items(id) ON DELETE CASCADE,
  quantity INTEGER DEFAULT 1 CHECK (quantity >= 1),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(player_id, item_id)
);

-- Player jutsus table (learned jutsus)
CREATE TABLE player_jutsus (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  jutsu_id TEXT REFERENCES jutsus(id) ON DELETE CASCADE,
  is_equipped BOOLEAN DEFAULT FALSE,
  mastery_level INTEGER DEFAULT 1 CHECK (mastery_level >= 1 AND mastery_level <= 15),
  mastery_xp INTEGER DEFAULT 0 CHECK (mastery_xp >= 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(player_id, jutsu_id)
);

-- Equipment table (equipped items)
CREATE TABLE equipment (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  slot TEXT CHECK (slot IN ('weapon', 'armor', 'accessory', 'special')),
  item_id TEXT REFERENCES items(id) ON DELETE CASCADE,
  equipped_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(player_id, slot)
);

-- Battle history table
CREATE TABLE battle_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  opponent_name TEXT NOT NULL,
  opponent_type TEXT CHECK (opponent_type IN ('player', 'npc', 'boss')) DEFAULT 'npc',
  result TEXT CHECK (result IN ('win', 'loss', 'draw')) NOT NULL,
  damage_dealt INTEGER DEFAULT 0 CHECK (damage_dealt >= 0),
  damage_taken INTEGER DEFAULT 0 CHECK (damage_taken >= 0),
  jutsus_used JSONB DEFAULT '[]',
  ryo_earned INTEGER DEFAULT 0 CHECK (ryo_earned >= 0),
  xp_earned INTEGER DEFAULT 0 CHECK (xp_earned >= 0),
  battle_duration INTEGER DEFAULT 0 CHECK (battle_duration >= 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Missions table
CREATE TABLE missions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  rank TEXT CHECK (rank IN ('d', 'c', 'b', 'a', 's')) NOT NULL,
  difficulty INTEGER DEFAULT 1 CHECK (difficulty >= 1 AND difficulty <= 10),
  ryo_reward INTEGER DEFAULT 0 CHECK (ryo_reward >= 0),
  xp_reward INTEGER DEFAULT 0 CHECK (xp_reward >= 0),
  item_rewards JSONB DEFAULT '[]',
  requirements JSONB DEFAULT '{}',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Player missions table (assigned missions)
CREATE TABLE player_missions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  mission_id UUID REFERENCES missions(id) ON DELETE CASCADE,
  status TEXT CHECK (status IN ('assigned', 'in_progress', 'completed', 'failed')) DEFAULT 'assigned',
  progress JSONB DEFAULT '{}',
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(player_id, mission_id)
);

-- Clans table
CREATE TABLE clans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  emblem_url TEXT,
  leader_id UUID REFERENCES players(id) ON DELETE SET NULL,
  member_count INTEGER DEFAULT 0 CHECK (member_count >= 0),
  max_members INTEGER DEFAULT 50 CHECK (max_members >= 1),
  level INTEGER DEFAULT 1 CHECK (level >= 1),
  experience INTEGER DEFAULT 0 CHECK (experience >= 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clan members table
CREATE TABLE clan_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  clan_id UUID REFERENCES clans(id) ON DELETE CASCADE,
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  role TEXT CHECK (role IN ('member', 'officer', 'leader')) DEFAULT 'member',
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(clan_id, player_id)
);

-- Banking table (player bank accounts)
CREATE TABLE banking (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  account_type TEXT CHECK (account_type IN ('savings', 'investment')) DEFAULT 'savings',
  balance INTEGER DEFAULT 5000 CHECK (balance >= 0), -- Starting bank balance
  interest_rate DECIMAL(5,4) DEFAULT 0.0000 CHECK (interest_rate >= 0),
  last_interest TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(player_id, account_type)
);

-- Chat messages table
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  channel TEXT CHECK (channel IN ('global', 'village', 'clan', 'private')) NOT NULL,
  recipient_id UUID REFERENCES players(id) ON DELETE CASCADE,
  message TEXT NOT NULL CHECK (LENGTH(message) <= 500),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- News table
CREATE TABLE news (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  author_id UUID REFERENCES players(id) ON DELETE SET NULL,
  category TEXT CHECK (category IN ('general', 'events', 'updates', 'community')) DEFAULT 'general',
  is_published BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Timers table (for various game timers)
CREATE TABLE timers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  timer_type TEXT CHECK (timer_type IN ('training', 'mission', 'battle', 'rest', 'custom')) NOT NULL,
  duration INTEGER NOT NULL CHECK (duration > 0),
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  metadata JSONB DEFAULT '{}'
);

-- Create indexes for better performance
CREATE INDEX idx_players_auth_user_id ON players(auth_user_id);
CREATE INDEX idx_players_username ON players(username);
CREATE INDEX idx_players_village_id ON players(village_id);
CREATE INDEX idx_players_last_active ON players(last_active);
CREATE INDEX idx_player_items_player_id ON player_items(player_id);
CREATE INDEX idx_player_jutsus_player_id ON player_jutsus(player_id);
CREATE INDEX idx_battle_history_player_id ON battle_history(player_id);
CREATE INDEX idx_battle_history_created_at ON battle_history(created_at);
CREATE INDEX idx_chat_messages_channel ON chat_messages(channel);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at);
CREATE INDEX idx_timers_player_id ON timers(player_id);
CREATE INDEX idx_timers_expires_at ON timers(expires_at);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers
CREATE TRIGGER update_villages_updated_at BEFORE UPDATE ON villages FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_players_updated_at BEFORE UPDATE ON players FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_clans_updated_at BEFORE UPDATE ON clans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_banking_updated_at BEFORE UPDATE ON banking FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update clan member count
CREATE OR REPLACE FUNCTION update_clan_member_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE clans SET member_count = member_count + 1 WHERE id = NEW.clan_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE clans SET member_count = member_count - 1 WHERE id = OLD.clan_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Add clan member count triggers
CREATE TRIGGER update_clan_member_count_insert AFTER INSERT ON clan_members FOR EACH ROW EXECUTE FUNCTION update_clan_member_count();
CREATE TRIGGER update_clan_member_count_delete AFTER DELETE ON clan_members FOR EACH ROW EXECUTE FUNCTION update_clan_member_count();

-- Function to automatically set display name from user metadata
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Set display name from user metadata if available
    IF NEW.raw_user_meta_data->>'display_name' IS NOT NULL THEN
        NEW.raw_user_meta_data = NEW.raw_user_meta_data || jsonb_build_object('display_name', NEW.raw_user_meta_data->>'display_name');
    ELSIF NEW.raw_user_meta_data->>'username' IS NOT NULL THEN
        NEW.raw_user_meta_data = NEW.raw_user_meta_data || jsonb_build_object('display_name', NEW.raw_user_meta_data->>'username');
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql' SECURITY DEFINER;

-- Trigger to automatically set display name on user creation
CREATE TRIGGER on_auth_user_created
    BEFORE INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();