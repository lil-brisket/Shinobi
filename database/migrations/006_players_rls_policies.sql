-- RLS Policies for players table
-- Implements secure access control for player data

-- Drop existing policies if they exist to avoid conflicts
DROP POLICY IF EXISTS "players.select.self" ON players;
DROP POLICY IF EXISTS "players.write.service" ON players;
DROP POLICY IF EXISTS "Players can view own data" ON players;

-- READ: a user can see only their own row
CREATE POLICY "players.select.self"
ON players
FOR SELECT
TO authenticated
USING ( auth.uid() = user_id );

-- WRITE: only service_role (Edge Functions) may insert/update/delete
CREATE POLICY "players.write.service"
ON players
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);
