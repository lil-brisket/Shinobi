-- Add title column to timers table
-- This migration adds the missing title column that the timer repository expects

ALTER TABLE timers ADD COLUMN title TEXT DEFAULT 'Unknown Timer';

-- Update existing timers with default titles based on their type
UPDATE timers SET title = 
  CASE 
    WHEN timer_type = 'training' THEN 'Training Session'
    WHEN timer_type = 'mission' THEN 'Mission'
    WHEN timer_type = 'battle' THEN 'Battle'
    WHEN timer_type = 'rest' THEN 'Rest'
    ELSE 'Custom Timer'
  END
WHERE title IS NULL OR title = 'Unknown Timer';

-- Make title NOT NULL after setting defaults
ALTER TABLE timers ALTER COLUMN title SET NOT NULL;
