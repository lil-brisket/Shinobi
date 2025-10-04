-- Row Level Security (RLS) Policies for Kage MMORPG
-- This file contains all RLS policies to ensure data security

-- Enable RLS on all tables
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_jutsus ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE clan_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE banking ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE timers ENABLE ROW LEVEL SECURITY;

-- Villages, items, jutsus, missions, clans, and news are public read-only
-- Players can only access their own data

-- Players policies
CREATE POLICY "Players can view their own profile" ON players
    FOR SELECT USING (auth.uid() = auth_user_id);

CREATE POLICY "Players can update their own profile" ON players
    FOR UPDATE USING (auth.uid() = auth_user_id);

CREATE POLICY "Players can insert their own profile" ON players
    FOR INSERT WITH CHECK (auth.uid() = auth_user_id);

-- Player items policies
CREATE POLICY "Players can view their own items" ON player_items
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Players can manage their own items" ON player_items
    FOR ALL USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

-- Player jutsus policies
CREATE POLICY "Players can view their own jutsus" ON player_jutsus
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Players can manage their own jutsus" ON player_jutsus
    FOR ALL USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

-- Equipment policies
CREATE POLICY "Players can view their own equipment" ON equipment
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Players can manage their own equipment" ON equipment
    FOR ALL USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

-- Battle history policies
CREATE POLICY "Players can view their own battle history" ON battle_history
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Players can insert their own battle history" ON battle_history
    FOR INSERT WITH CHECK (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

-- Player missions policies
CREATE POLICY "Players can view their own missions" ON player_missions
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Players can manage their own missions" ON player_missions
    FOR ALL USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

-- Clan members policies
CREATE POLICY "Players can view their clan membership" ON clan_members
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Clan leaders can manage clan members" ON clan_members
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM clans 
            WHERE id = clan_id AND leader_id IN (
                SELECT id FROM players WHERE auth_user_id = auth.uid()
            )
        )
    );

-- Banking policies
CREATE POLICY "Players can view their own bank accounts" ON banking
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Players can manage their own bank accounts" ON banking
    FOR ALL USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

-- Chat messages policies
CREATE POLICY "Players can view messages in channels they're part of" ON chat_messages
    FOR SELECT USING (
        -- Global chat is visible to all authenticated users
        channel = 'global' OR
        -- Village chat is visible to players in the same village
        (channel = 'village' AND player_id IN (
            SELECT p.id FROM players p 
            WHERE p.village_id = (
                SELECT village_id FROM players WHERE auth_user_id = auth.uid()
            )
        )) OR
        -- Clan chat is visible to clan members
        (channel = 'clan' AND EXISTS (
            SELECT 1 FROM clan_members cm1
            JOIN clan_members cm2 ON cm1.clan_id = cm2.clan_id
            WHERE cm1.player_id = chat_messages.player_id
            AND cm2.player_id IN (
                SELECT id FROM players WHERE auth_user_id = auth.uid()
            )
        )) OR
        -- Private messages are visible to sender and recipient
        (channel = 'private' AND (
            player_id IN (SELECT id FROM players WHERE auth_user_id = auth.uid()) OR
            recipient_id IN (SELECT id FROM players WHERE auth_user_id = auth.uid())
        ))
    );

CREATE POLICY "Players can send messages" ON chat_messages
    FOR INSERT WITH CHECK (
        player_id IN (SELECT id FROM players WHERE auth_user_id = auth.uid())
    );

-- Timers policies
CREATE POLICY "Players can view their own timers" ON timers
    FOR SELECT USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Players can manage their own timers" ON timers
    FOR ALL USING (
        player_id IN (
            SELECT id FROM players WHERE auth_user_id = auth.uid()
        )
    );

-- Public read access for reference tables
CREATE POLICY "Anyone can view villages" ON villages
    FOR SELECT USING (true);

CREATE POLICY "Anyone can view items" ON items
    FOR SELECT USING (true);

CREATE POLICY "Anyone can view jutsus" ON jutsus
    FOR SELECT USING (true);

CREATE POLICY "Anyone can view missions" ON missions
    FOR SELECT USING (true);

CREATE POLICY "Anyone can view clans" ON clans
    FOR SELECT USING (true);

CREATE POLICY "Anyone can view published news" ON news
    FOR SELECT USING (is_published = true);

-- Admin policies (for future use)
-- These would be used by service role or admin users
-- CREATE POLICY "Admins can manage all data" ON players
--     FOR ALL USING (auth.jwt() ->> 'role' = 'admin');
