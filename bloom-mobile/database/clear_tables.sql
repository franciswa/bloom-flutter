-- Clear all tables in the correct order to handle foreign key constraints
DELETE FROM messages;
DELETE FROM notifications;
DELETE FROM matches;
DELETE FROM date_preferences;
DELETE FROM user_settings;
DELETE FROM profiles;

-- Reset sequences if any
ALTER SEQUENCE IF EXISTS messages_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS notifications_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS matches_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS date_preferences_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS user_settings_id_seq RESTART WITH 1;
