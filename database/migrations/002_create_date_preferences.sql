-- Create date_preferences table
CREATE TABLE IF NOT EXISTS date_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  desired_zodiac TEXT NOT NULL,
  date_type TEXT NOT NULL,
  preferred_date DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT valid_status CHECK (status IN ('pending', 'matching', 'matched', 'cancelled', 'completed')),
  CONSTRAINT valid_date_type CHECK (date_type IN ('Dinner', 'Coffee', 'Drinks', 'Games/Arcade', 'Picnic', 'Activity/Adventure', 'Other/Anything'))
);

-- Add RLS policies
ALTER TABLE date_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own date preferences"
  ON date_preferences FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own date preferences"
  ON date_preferences FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own date preferences"
  ON date_preferences FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own date preferences"
  ON date_preferences FOR DELETE
  USING (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_date_preferences_updated_at
  BEFORE UPDATE ON date_preferences
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create index for faster queries
CREATE INDEX date_preferences_user_id_idx ON date_preferences(user_id);
CREATE INDEX date_preferences_status_idx ON date_preferences(status);
