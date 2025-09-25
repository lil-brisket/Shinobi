-- Fix Villages Table Migration
-- Drops existing villages table and recreates it with correct UUID type

-- Drop the existing villages table if it exists (this will cascade to any dependent objects)
DROP TABLE IF EXISTS villages CASCADE;

-- Create villages table with correct UUID type
CREATE TABLE villages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  emblem text NOT NULL,
  tile_x int NOT NULL,
  tile_y int NOT NULL,
  description text NOT NULL,
  kage_user_id uuid,
  max_clans int NOT NULL DEFAULT 3,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Create indices
CREATE INDEX idx_villages_kage ON villages(kage_user_id);
CREATE INDEX idx_villages_coordinates ON villages(tile_x, tile_y);

-- Function to update villages updated_at timestamp
CREATE OR REPLACE FUNCTION update_villages_timestamp()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update villages timestamp
CREATE TRIGGER update_villages_updated_at
  BEFORE UPDATE ON villages
  FOR EACH ROW
  EXECUTE FUNCTION update_villages_timestamp();

-- Insert default villages with predefined UUIDs for consistency
INSERT INTO villages (id, name, emblem, tile_x, tile_y, description) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'Willowshade Village', '🌿', 10, 15, 'A village hidden among ancient willow trees, known for its natural healing techniques and connection to nature.'),
  ('550e8400-e29b-41d4-a716-446655440002', 'Ashpeak Village', '🔥', 25, 8, 'Built within the peaks of volcanic mountains, this village masters fire-based techniques and volcanic ash manipulation.'),
  ('550e8400-e29b-41d4-a716-446655440003', 'Stormvale Village', '⚡', 5, 25, 'A village that harnesses the power of storms, specializing in lightning techniques and weather manipulation.'),
  ('550e8400-e29b-41d4-a716-446655440004', 'Snowhollow Village', '❄️', 30, 20, 'Hidden in the frozen valleys, this village excels in ice techniques and survival in extreme cold conditions.'),
  ('550e8400-e29b-41d4-a716-446655440005', 'Shadowfen Village', '🌑', 15, 30, 'A mysterious village in the shadowy wetlands, known for stealth techniques and shadow manipulation arts.');

-- Enable RLS
ALTER TABLE villages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for villages
CREATE POLICY "Anyone can read villages" ON villages FOR SELECT USING (true);
CREATE POLICY "Only kage can update their village" ON villages FOR UPDATE 
  USING (kage_user_id = auth.uid());
