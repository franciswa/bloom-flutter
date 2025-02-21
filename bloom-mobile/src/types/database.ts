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
  created_at: string;
  conversation_id: string;
  sender_id: string;
  content: string;
  read_at: string | null;
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
