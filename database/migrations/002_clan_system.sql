-- Clan System Migration
-- Creates all tables, enums, and constraints for the comprehensive clan system

-- Enums
CREATE TYPE clan_role AS ENUM ('LEADER','ADVISOR','MEMBER');
CREATE TYPE application_status AS ENUM ('PENDING','APPROVED','REJECTED','WITHDRAWN');

-- Villages (assume exists; add columns if not)
-- Add kage_user_id and max_clans columns to villages table
ALTER TABLE villages ADD COLUMN IF NOT EXISTS kage_user_id uuid;
ALTER TABLE villages ADD COLUMN IF NOT EXISTS max_clans int DEFAULT 3;

-- Clans
CREATE TABLE IF NOT EXISTS clans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  village_id uuid NOT NULL REFERENCES villages(id) ON DELETE CASCADE,
  emblem_url text,
  description text,
  leader_id uuid NOT NULL REFERENCES auth.users(id),
  score int NOT NULL DEFAULT 0,
  wins int NOT NULL DEFAULT 0,
  losses int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_clans_village ON clans(village_id);
CREATE INDEX IF NOT EXISTS idx_clans_leader ON clans(leader_id);

-- Clan Members (one clan per user)
CREATE TABLE IF NOT EXISTS clan_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  clan_id uuid NOT NULL REFERENCES clans(id) ON DELETE CASCADE,
  user_id uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  role clan_role NOT NULL DEFAULT 'MEMBER',
  display_name text NOT NULL,
  joined_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_clan_members_clan ON clan_members(clan_id);
CREATE INDEX IF NOT EXISTS idx_clan_members_user ON clan_members(user_id);

-- Applications (one PENDING per user globally)
CREATE TABLE IF NOT EXISTS clan_applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  clan_id uuid NOT NULL REFERENCES clans(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status application_status NOT NULL DEFAULT 'PENDING',
  message varchar(280),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Enforce unique "pending per user" via partial unique index
CREATE UNIQUE INDEX IF NOT EXISTS uniq_pending_app_per_user
  ON clan_applications(user_id)
  WHERE status = 'PENDING';

CREATE INDEX IF NOT EXISTS idx_clan_applications_clan ON clan_applications(clan_id);
CREATE INDEX IF NOT EXISTS idx_clan_applications_user ON clan_applications(user_id);

-- Board posts
CREATE TABLE IF NOT EXISTS clan_board_posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  clan_id uuid NOT NULL REFERENCES clans(id) ON DELETE CASCADE,
  author_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  author_name text NOT NULL,
  content text NOT NULL,
  pinned boolean NOT NULL DEFAULT false,
  likes int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_board_posts_clan ON clan_board_posts(clan_id);
CREATE INDEX IF NOT EXISTS idx_board_posts_author ON clan_board_posts(author_id);
CREATE INDEX IF NOT EXISTS idx_board_posts_pinned ON clan_board_posts(clan_id, pinned, created_at);

-- Helper: keep updated_at
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$ LANGUAGE plpgsql;

-- Triggers for updated_at
DROP TRIGGER IF EXISTS trg_clans_updated ON clans;
CREATE TRIGGER trg_clans_updated BEFORE UPDATE ON clans
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_clan_applications_updated ON clan_applications;
CREATE TRIGGER trg_clan_applications_updated BEFORE UPDATE ON clan_applications
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- RLS Policies
ALTER TABLE clans ENABLE ROW LEVEL SECURITY;
ALTER TABLE clan_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE clan_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE clan_board_posts ENABLE ROW LEVEL SECURITY;

-- Clans policies
CREATE POLICY "Anyone can read clans" ON clans FOR SELECT USING (true);
CREATE POLICY "Kage can create clans" ON clans FOR INSERT 
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM villages 
      WHERE villages.id = clans.village_id 
      AND villages.kage_user_id = auth.uid()
      AND (
        SELECT COUNT(*) FROM clans 
        WHERE village_id = clans.village_id
      ) < (
        SELECT max_clans FROM villages 
        WHERE id = clans.village_id
      )
    )
  );
CREATE POLICY "Kage or leader can update clans" ON clans FOR UPDATE 
  USING (
    EXISTS (
      SELECT 1 FROM villages 
      WHERE villages.id = clans.village_id 
      AND villages.kage_user_id = auth.uid()
    ) OR leader_id = auth.uid()
  );
CREATE POLICY "Kage or leader can delete clans" ON clans FOR DELETE 
  USING (
    EXISTS (
      SELECT 1 FROM villages 
      WHERE villages.id = clans.village_id 
      AND villages.kage_user_id = auth.uid()
    ) OR leader_id = auth.uid()
  );

-- Clan members policies
CREATE POLICY "Members can read clan members" ON clan_members FOR SELECT 
  USING (
    user_id = auth.uid() OR 
    EXISTS (
      SELECT 1 FROM clan_members cm 
      WHERE cm.clan_id = clan_members.clan_id 
      AND cm.user_id = auth.uid()
    )
  );
CREATE POLICY "System can insert clan members" ON clan_members FOR INSERT 
  WITH CHECK (true); -- Controlled via edge functions
CREATE POLICY "Leaders can update clan members" ON clan_members FOR UPDATE 
  USING (
    EXISTS (
      SELECT 1 FROM clan_members cm 
      JOIN clans c ON c.id = cm.clan_id 
      WHERE cm.clan_id = clan_members.clan_id 
      AND cm.user_id = auth.uid() 
      AND (cm.role = 'LEADER' OR cm.role = 'ADVISOR')
    )
  );
CREATE POLICY "Users can leave clan" ON clan_members FOR DELETE 
  USING (user_id = auth.uid());

-- Clan applications policies
CREATE POLICY "Users can read own applications" ON clan_applications FOR SELECT 
  USING (user_id = auth.uid());
CREATE POLICY "Leaders can read clan applications" ON clan_applications FOR SELECT 
  USING (
    EXISTS (
      SELECT 1 FROM clan_members cm 
      WHERE cm.clan_id = clan_applications.clan_id 
      AND cm.user_id = auth.uid() 
      AND (cm.role = 'LEADER' OR cm.role = 'ADVISOR')
    )
  );
CREATE POLICY "Users can create applications" ON clan_applications FOR INSERT 
  WITH CHECK (
    user_id = auth.uid() AND
    NOT EXISTS (
      SELECT 1 FROM clan_members 
      WHERE user_id = auth.uid()
    ) AND
    NOT EXISTS (
      SELECT 1 FROM clan_applications 
      WHERE user_id = auth.uid() AND status = 'PENDING'
    )
  );
CREATE POLICY "Users can update own applications" ON clan_applications FOR UPDATE 
  USING (user_id = auth.uid());
CREATE POLICY "Leaders can update applications" ON clan_applications FOR UPDATE 
  USING (
    EXISTS (
      SELECT 1 FROM clan_members cm 
      WHERE cm.clan_id = clan_applications.clan_id 
      AND cm.user_id = auth.uid() 
      AND (cm.role = 'LEADER' OR cm.role = 'ADVISOR')
    )
  );

-- Board posts policies
CREATE POLICY "Clan members can read posts" ON clan_board_posts FOR SELECT 
  USING (
    EXISTS (
      SELECT 1 FROM clan_members 
      WHERE clan_id = clan_board_posts.clan_id 
      AND user_id = auth.uid()
    )
  );
CREATE POLICY "Clan members can create posts" ON clan_board_posts FOR INSERT 
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM clan_members 
      WHERE clan_id = clan_board_posts.clan_id 
      AND user_id = auth.uid()
    )
  );
CREATE POLICY "Advisors can update posts" ON clan_board_posts FOR UPDATE 
  USING (
    EXISTS (
      SELECT 1 FROM clan_members cm 
      WHERE cm.clan_id = clan_board_posts.clan_id 
      AND cm.user_id = auth.uid() 
      AND (cm.role = 'LEADER' OR cm.role = 'ADVISOR')
    )
  );
CREATE POLICY "Leaders can delete posts" ON clan_board_posts FOR DELETE 
  USING (
    EXISTS (
      SELECT 1 FROM clan_members cm 
      WHERE cm.clan_id = clan_board_posts.clan_id 
      AND cm.user_id = auth.uid() 
      AND cm.role = 'LEADER'
    )
  );

-- Constraint: max 3 clans per village (enforced via trigger)
CREATE OR REPLACE FUNCTION check_max_clans_per_village() RETURNS trigger AS $$
BEGIN
  IF (
    SELECT COUNT(*) FROM clans 
    WHERE village_id = NEW.village_id
  ) >= (
    SELECT max_clans FROM villages 
    WHERE id = NEW.village_id
  ) THEN
    RAISE EXCEPTION 'Maximum number of clans per village exceeded';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_max_clans
  BEFORE INSERT ON clans
  FOR EACH ROW
  EXECUTE FUNCTION check_max_clans_per_village();

-- Constraint: max 3 advisors per clan
CREATE OR REPLACE FUNCTION check_max_advisors_per_clan() RETURNS trigger AS $$
BEGIN
  IF NEW.role = 'ADVISOR' AND (
    SELECT COUNT(*) FROM clan_members 
    WHERE clan_id = NEW.clan_id AND role = 'ADVISOR'
  ) >= 3 THEN
    RAISE EXCEPTION 'Maximum number of advisors per clan is 3';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_max_advisors
  BEFORE INSERT OR UPDATE ON clan_members
  FOR EACH ROW
  EXECUTE FUNCTION check_max_advisors_per_clan();
