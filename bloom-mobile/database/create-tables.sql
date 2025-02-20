-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    name TEXT,
    birth_info JSONB,
    natal_chart JSONB,
    photos JSONB[],
    personality_ratings JSONB,
    lifestyle_ratings JSONB,
    values_ratings JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- User settings table
CREATE TABLE IF NOT EXISTS public.user_settings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    theme_mode TEXT DEFAULT 'light',
    dark_mode BOOLEAN DEFAULT false,
    notifications_enabled BOOLEAN DEFAULT true,
    notification_preferences JSONB DEFAULT '{"matches": true, "messages": true, "date_reminders": true}'::jsonb,
    distance_range INTEGER DEFAULT 50,
    age_range_min INTEGER DEFAULT 18,
    age_range_max INTEGER DEFAULT 45,
    show_zodiac BOOLEAN DEFAULT true,
    show_birth_time BOOLEAN DEFAULT true,
    privacy_settings JSONB DEFAULT '{"show_location": true, "show_age": true, "show_profile_photo": true}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Push tokens table
CREATE TABLE IF NOT EXISTS public.push_tokens (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    token TEXT NOT NULL,
    device_id TEXT,
    platform TEXT,
    is_valid BOOLEAN DEFAULT true,
    last_used TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Matches table
CREATE TABLE IF NOT EXISTS public.matches (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user1_id UUID REFERENCES auth.users(id),
    user2_id UUID REFERENCES auth.users(id),
    compatibility_score INTEGER,
    astrological_compatibility JSONB,
    questionnaire_compatibility INTEGER,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Date preferences table
CREATE TABLE IF NOT EXISTS public.date_preferences (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    desired_zodiac TEXT NOT NULL,
    date_type TEXT NOT NULL,
    preferred_date DATE NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT valid_date_type CHECK (
        date_type IN ('Dinner', 'Coffee', 'Drinks', 'Games/Arcade', 'Picnic', 'Activity/Adventure', 'Other/Anything')
    ),
    CONSTRAINT valid_zodiac CHECK (
        desired_zodiac IN ('Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces')
    ),
    CONSTRAINT valid_status CHECK (
        status IN ('pending', 'matching', 'matched', 'cancelled', 'completed')
    ),
    CONSTRAINT future_date CHECK (
        preferred_date >= CURRENT_DATE
    )
);

-- Messages table
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_system_message BOOLEAN DEFAULT false,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Archived messages table
CREATE TABLE IF NOT EXISTS public.archived_messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    match_id UUID NOT NULL,
    sender_id UUID NOT NULL,
    content TEXT NOT NULL,
    is_system_message BOOLEAN DEFAULT false,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ DEFAULT now()
);

-- Notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL,
    data JSONB,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS profiles_user_id_idx ON profiles(user_id);
CREATE INDEX IF NOT EXISTS user_settings_user_id_idx ON user_settings(user_id);
CREATE INDEX IF NOT EXISTS push_tokens_user_id_idx ON push_tokens(user_id);
CREATE INDEX IF NOT EXISTS push_tokens_token_idx ON push_tokens(token);
CREATE INDEX IF NOT EXISTS matches_user1_id_idx ON matches(user1_id);
CREATE INDEX IF NOT EXISTS matches_user2_id_idx ON matches(user2_id);
CREATE INDEX IF NOT EXISTS messages_match_id_idx ON messages(match_id);
CREATE INDEX IF NOT EXISTS messages_sender_id_idx ON messages(sender_id);
CREATE INDEX IF NOT EXISTS archived_messages_match_id_idx ON archived_messages(match_id);
CREATE INDEX IF NOT EXISTS archived_messages_sender_id_idx ON archived_messages(sender_id);
CREATE INDEX IF NOT EXISTS notifications_user_id_idx ON notifications(user_id);
CREATE INDEX IF NOT EXISTS notifications_type_idx ON notifications(type);
CREATE INDEX IF NOT EXISTS date_preferences_user_id_idx ON date_preferences(user_id);
CREATE INDEX IF NOT EXISTS date_preferences_status_idx ON date_preferences(status);
CREATE INDEX IF NOT EXISTS date_preferences_preferred_date_idx ON date_preferences(preferred_date);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE push_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE archived_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE date_preferences ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Profiles
CREATE POLICY "Users can view their own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- User Settings
CREATE POLICY "Users can view their own settings"
    ON user_settings FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own settings"
    ON user_settings FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Push Tokens
CREATE POLICY "Users can manage their own push tokens"
    ON push_tokens FOR ALL
    USING (auth.uid() = user_id);

-- Matches
CREATE POLICY "Users can view their matches"
    ON matches FOR SELECT
    USING (
        auth.uid() = user1_id OR
        auth.uid() = user2_id
    );

-- Messages
CREATE POLICY "Users can read messages in their matches"
    ON messages FOR SELECT
    USING (
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

CREATE POLICY "Users can insert messages in their matches"
    ON messages FOR INSERT
    WITH CHECK (
        auth.uid() = sender_id AND
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

CREATE POLICY "Users can update their own messages"
    ON messages FOR UPDATE
    USING (auth.uid() = sender_id)
    WITH CHECK (auth.uid() = sender_id);

-- Archived Messages
CREATE POLICY "Users can read their archived messages"
    ON archived_messages FOR SELECT
    USING (
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

-- Notifications
CREATE POLICY "Users can view their own notifications"
    ON notifications FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications"
    ON notifications FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Date Preferences
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

-- Add trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create updated_at triggers for all tables
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_settings_updated_at
    BEFORE UPDATE ON user_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_push_tokens_updated_at
    BEFORE UPDATE ON push_tokens
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_matches_updated_at
    BEFORE UPDATE ON matches
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_messages_updated_at
    BEFORE UPDATE ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_notifications_updated_at
    BEFORE UPDATE ON notifications
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_date_preferences_updated_at
    BEFORE UPDATE ON date_preferences
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable realtime
BEGIN;
DROP PUBLICATION IF EXISTS supabase_realtime;
CREATE PUBLICATION supabase_realtime;
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE matches;
ALTER PUBLICATION supabase_realtime ADD TABLE user_settings;
ALTER PUBLICATION supabase_realtime ADD TABLE date_preferences;
COMMIT;

-- Grant necessary permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres;
