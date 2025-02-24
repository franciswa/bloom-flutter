import { ZodiacSign } from './chart';
import { DateType } from '../services/datePreferences';

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: Profile;
        Insert: Omit<Profile, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<Profile, 'id' | 'created_at' | 'updated_at'>>;
      };
      date_preferences: {
        Row: DatePreference;
        Insert: Omit<DatePreference, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<DatePreference, 'id' | 'created_at' | 'updated_at'>>;
      };
      matches: {
        Row: Match;
        Insert: Omit<Match, 'id' | 'created_at'>;
        Update: Partial<Omit<Match, 'id' | 'created_at'>>;
      };
      messages: {
        Row: Message;
        Insert: Omit<Message, 'id' | 'created_at'>;
        Update: Partial<Omit<Message, 'id' | 'created_at'>>;
      };
      conversations: {
        Row: Conversation;
        Insert: Omit<Conversation, 'id' | 'created_at'>;
        Update: Partial<Omit<Conversation, 'id' | 'created_at'>>;
      };
      notifications: {
        Row: Notification;
        Insert: Omit<Notification, 'id' | 'created_at'>;
        Update: Partial<Omit<Notification, 'id' | 'created_at'>>;
      };
      push_tokens: {
        Row: PushToken;
        Insert: Omit<PushToken, 'id' | 'created_at'>;
        Update: Partial<Omit<PushToken, 'id' | 'created_at'>>;
      };
      user_settings: {
        Row: UserSettings;
        Insert: Omit<UserSettings, 'id'>;
        Update: Partial<Omit<UserSettings, 'id'>>;
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      exec_sql: {
        Args: { sql: string };
        Returns: unknown;
      };
    };
    Enums: {
      [_ in never]: never;
    };
  };
}

export interface DatePreference {
  id: string;
  user_id: string;
  desired_zodiac: ZodiacSign;
  date_type: DateType;
  preferred_date: string;
  status: 'pending' | 'matching' | 'matched' | 'cancelled' | 'completed';
  created_at: string;
  updated_at: string;
}

export interface Profile {
  id: string;
  created_at: string;
  updated_at: string;
  email: string;
  name: string | null;
  birth_date: string | null;
  birth_time: string | null;
  birth_location: {
    latitude: number;
    longitude: number;
    name: string;
  } | null;
  photos: {
    id: string;
    url: string;
    is_primary: boolean;
    uploaded_at: string;
  }[];
  personality_ratings: Record<string, number>;
  lifestyle_ratings: Record<string, number>;
  values_ratings: Record<string, number>;
  bio: string | null;
  gender: 'male' | 'female' | 'non-binary' | null;
  interested_in: ('male' | 'female' | 'non-binary')[];
  age_range_preference: {
    min: number;
    max: number;
  } | null;
  location: {
    latitude: number;
    longitude: number;
    name: string;
  } | null;
  max_distance: number | null;
  notifications_enabled: boolean;
  email_notifications_enabled: boolean;
  last_active: string;
  is_profile_complete: boolean;
  is_verified: boolean;
  is_premium: boolean;
  premium_expires_at: string | null;
}

export interface Match {
  id: string;
  created_at: string;
  user1_id: string;
  user2_id: string;
  compatibility_score: number;
  astrological_aspects: {
    planet1: string;
    planet2: string;
    aspect_type: string;
    orb: number;
    significance: number;
  }[];
  status: 'pending' | 'accepted' | 'rejected';
  last_interaction: string;
}

export interface Message {
  id: string;
  match_id: string;
  sender_id: string;
  content: string;
  is_system_message: boolean;
  read: boolean;
  edited_at?: string;
  created_at: string;
  updated_at: string;
}

export interface TypingStatus {
  userId: string;
  isTyping: boolean;
  matchId: string;
}

export interface Conversation {
  id: string;
  created_at: string;
  user1_id: string;
  user2_id: string;
  last_message_at: string;
  last_message_preview: string;
  unread_count: number;
}

export interface Notification {
  id: string;
  created_at: string;
  user_id: string;
  type: 'match' | 'message' | 'like' | 'system';
  title: string;
  message: string;
  read_at: string | null;
  action_url: string | null;
  metadata: Record<string, any>;
}

export interface PushToken {
  id: string;
  created_at: string;
  user_id: string;
  token: string;
  device_type: 'ios' | 'android' | 'web';
  is_active: boolean;
  last_used: string;
}

export interface UserSettings {
  id: string;
  user_id: string;
  theme: 'light' | 'dark' | 'system';
  language: string;
  push_notifications: {
    matches: boolean;
    messages: boolean;
    likes: boolean;
    system: boolean;
  };
  email_notifications: {
    matches: boolean;
    messages: boolean;
    likes: boolean;
    system: boolean;
    marketing: boolean;
  };
  privacy: {
    show_online_status: boolean;
    show_last_active: boolean;
    show_profile_to: 'everyone' | 'matches_only' | 'nobody';
  };
  distance_unit: 'km' | 'mi';
  time_format: '12h' | '24h';
  date_format: 'MM/DD/YYYY' | 'DD/MM/YYYY' | 'YYYY-MM-DD';
  updated_at: string;
}
