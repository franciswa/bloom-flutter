export interface Profile {
  id: string;
  user_id: string;
  name: string;
  birth_info?: BirthInfo;
  natal_chart?: NatalChart;
  photos: Photo[];
  personality_ratings?: Record<string, number>;
  lifestyle_ratings?: Record<string, number>;
  values_ratings?: Record<string, number>;
  created_at: string;
  updated_at: string;
}

export interface BirthInfo {
  date: string;
  time: string;
  latitude: number;
  longitude: number;
  city?: string;
}

export interface NatalChart {
  signs: {
    sun: string;
    moon: string;
    ascendant: string;
    mercury: string;
    venus: string;
    mars: string;
    jupiter: string;
    saturn: string;
    uranus: string;
    neptune: string;
    pluto: string;
  };
  planets: {
    [key: string]: {
      planet: string;
      house: number;
    };
  };
}

export interface Photo {
  id: string;
  url: string;
  order: number;
}

export interface Message {
  id: string;
  conversation_id: string;
  sender_id: string;
  content: string;
  created_at: string;
  read: boolean;
}

export interface Conversation {
  id: string;
  participants: string[];
  created_at: string;
  updated_at: string;
  last_message?: Message;
}

export interface Notification {
  id: string;
  user_id: string;
  title: string;
  message: string;
  type: 'match' | 'message' | 'system' | 'date_reminder';
  data?: Record<string, any>;
  read: boolean;
  created_at: string;
  updated_at: string;
}

export interface UserSettings {
  id: string;
  user_id: string;
  theme_mode: 'light' | 'dark';
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

export interface PushToken {
  id: string;
  user_id: string;
  token: string;
  device_id: string;
  platform: string;
  is_valid: boolean;
  last_used: string;
  created_at: string;
  updated_at: string;
}

export type DateType = 
  | 'Dinner'
  | 'Coffee'
  | 'Drinks'
  | 'Games/Arcade'
  | 'Picnic'
  | 'Activity/Adventure'
  | 'Other/Anything';

export type DateStatus = 
  | 'pending'
  | 'matching'
  | 'matched'
  | 'cancelled'
  | 'completed';

export interface DatePreference {
  id: string;
  user_id: string;
  desired_zodiac: string;
  date_type: DateType;
  preferred_date: string;
  status: DateStatus;
  created_at: string;
  updated_at: string;
}

export interface Match {
  id: string;
  user1_id: string;
  user2_id: string;
  compatibility_score: number;
  astrological_compatibility: {
    total: number;
    aspect: {
      total: number;
      aspectScore: number;
      elementScore: number;
      aspectDetails: Array<{
        planet1: string;
        planet2: string;
        aspect: string;
        orb: number;
        score: number;
      }>;
    };
    element: {
      elementScore: number;
      signModifier: number;
    };
  };
  questionnaire_compatibility: number;
  status: 'pending' | 'accepted' | 'rejected';
  created_at: string;
  updated_at: string;
}
