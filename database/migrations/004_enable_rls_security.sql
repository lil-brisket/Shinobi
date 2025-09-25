-- Enable Row Level Security on all specified tables
-- This migration ensures RLS is enabled on all tables that handle user data

-- Core player tables
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_stats ENABLE ROW LEVEL SECURITY;

-- Banking system tables
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE interest_offers ENABLE ROW LEVEL SECURITY;

-- Hospital system tables
ALTER TABLE hospital_stays ENABLE ROW LEVEL SECURITY;
ALTER TABLE heals ENABLE ROW LEVEL SECURITY;

-- Inventory system tables
ALTER TABLE player_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipped_items ENABLE ROW LEVEL SECURITY;

-- Jutsu system tables
ALTER TABLE jutsu_cooldowns ENABLE ROW LEVEL SECURITY;

-- Battle system tables
ALTER TABLE battle_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE battles ENABLE ROW LEVEL SECURITY;

-- Note: leaderboards is a materialized view and doesn't support RLS directly
-- The underlying tables (players, player_progress) already have RLS enabled
