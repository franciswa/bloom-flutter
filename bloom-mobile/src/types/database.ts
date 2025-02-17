export type DateType = 'Dinner' | 'Coffee' | 'Drinks' | 'Games/Arcade' | 'Picnic' | 'Activity/Adventure' | 'Other/Anything';

export type MatchStatus = 'pending' | 'accepted' | 'rejected';
export type DatePreferenceStatus = 'pending' | 'matching' | 'matched' | 'cancelled' | 'expired';
export type NotificationType = 'match' | 'message' | 'date_reminder' | 'system';
export type ThemeMode = 'light' | 'dark' | 'system';
export type PlatformType = 'ios' | 'android' | 'web';

export interface Profile {
  id: string;
  email: string;
  birth_date: string | null;
  location_city: string | null;
  personality_ratings: Record<string, number>;
  lifestyle_ratings: Record<string, number>;
  values_ratings: Record<string, number>;
  created_at: string;
  updated_at: string;
}

export interface Match {
  id: string;
  user1_id: string;
  user2_id: string;
  date_preferences_id: string;
  match_date: string;
  date_type: DateType;
  status: MatchStatus;
  compatibility_score: number;
  created_at: string;
  updated_at: string;
}

export interface DatePreference {
  id: string;
  user_id: string;
  desired_zodiac: string;
  date_type: DateType;
  preferred_date: string;
  status: DatePreferenceStatus;
  created_at: string;
  updated_at: string;
}

export interface Message {
  id: string;
  match_id: string;
  sender_id: string;
  content: string;
  is_system_message: boolean;
  created_at: string;
  updated_at: string;
}

export interface ArchivedMessage extends Message {
  archived_at: string;
}

export interface UserSettings {
  id: string;
  user_id: string;
  theme_mode: ThemeMode;
  dark_mode: boolean;
  notifications_enabled: boolean;
  notification_preferences: {
    matches: boolean;
    messages: boolean;
    date_reminders: boolean;
  };
  distance_range: number;
  age_range_min: number;
  age_range_max: number;
  show_zodiac: boolean;
  show_birth_time: boolean;
  privacy_settings: {
    show_location: boolean;
    show_age: boolean;
    show_profile_photo: boolean;
  };
  created_at: string;
  updated_at: string;
}

export interface Notification {
  id: string;
  user_id: string;
  type: NotificationType;
  title: string;
  message: string;
  data?: {
    match_id?: string;
    message_id?: string;
    date_preference_id?: string;
  };
  read: boolean;
  created_at: string;
  updated_at: string;
}

export interface PushToken {
  id: string;
  user_id: string;
  token: string;
  device_id: string;
  platform: PlatformType;
  is_valid: boolean;
  last_used_at: string;
  created_at: string;
  updated_at: string;
}

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: Profile;
        Insert: Omit<Profile, 'created_at' | 'updated_at'>;
        Update: Partial<Omit<Profile, 'id' | 'created_at' | 'updated_at'>>;
      };
      matches: {
        Row: Match;
        Insert: Omit<Match, 'created_at' | 'updated_at'>;
        Update: Partial<Omit<Match, 'id' | 'created_at' | 'updated_at'>>;
      };
      date_preferences: {
        Row: DatePreference;
        Insert: Omit<DatePreference, 'created_at' | 'updated_at'>;
        Update: Partial<Omit<DatePreference, 'id' | 'created_at' | 'updated_at'>>;
      };
      messages: {
        Row: Message;
        Insert: Omit<Message, 'created_at' | 'updated_at'>;
        Update: Partial<Omit<Message, 'id' | 'created_at' | 'updated_at'>>;
      };
      archived_messages: {
        Row: ArchivedMessage;
        Insert: Omit<ArchivedMessage, 'archived_at'>;
        Update: never;  // Archived messages are read-only
      };
      user_settings: {
        Row: UserSettings;
        Insert: Omit<UserSettings, 'created_at' | 'updated_at'>;
        Update: Partial<Omit<UserSettings, 'id' | 'created_at' | 'updated_at'>>;
      };
      notifications: {
        Row: Notification;
        Insert: Omit<Notification, 'created_at' | 'updated_at'>;
        Update: Partial<Omit<Notification, 'id' | 'created_at' | 'updated_at'>>;
      };
      push_tokens: {
        Row: PushToken;
        Insert: Omit<PushToken, 'id' | 'created_at' | 'updated_at' | 'last_used_at'>;
        Update: Partial<Omit<PushToken, 'id' | 'created_at' | 'updated_at' | 'last_used_at'>>;
      };
    };
  };
}
