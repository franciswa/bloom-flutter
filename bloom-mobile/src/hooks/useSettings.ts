import { useState, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { UserSettings } from '../types/database';

const defaultSettings: UserSettings = {
  id: '',
  user_id: '',
  theme: 'system',
  language: 'en',
  push_notifications: {
    matches: true,
    messages: true,
    likes: true,
    system: true,
  },
  email_notifications: {
    matches: true,
    messages: true,
    likes: true,
    system: true,
    marketing: false,
  },
  privacy: {
    show_online_status: true,
    show_last_active: true,
    show_profile_to: 'everyone',
  },
  distance_unit: 'mi',
  time_format: '12h',
  date_format: 'MM/DD/YYYY',
  updated_at: new Date().toISOString(),
};

export function useSettings(userId: string) {
  const [settings, setSettings] = useState<UserSettings>(defaultSettings);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadSettings = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const { data, error: err } = await supabase
        .from('user_settings')
        .select('*')
        .eq('user_id', userId)
        .single();

      if (err) throw err;
      setSettings(data || defaultSettings);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load settings');
    } finally {
      setLoading(false);
    }
  }, [userId]);

  const updateSettings = useCallback(async (updates: Partial<UserSettings>) => {
    try {
      setError(null);

      const { error: err } = await supabase
        .from('user_settings')
        .upsert({
          ...settings,
          ...updates,
          user_id: userId,
          updated_at: new Date().toISOString(),
        });

      if (err) throw err;
      setSettings(prev => ({ ...prev, ...updates }));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update settings');
      throw err;
    }
  }, [userId, settings]);

  return {
    settings,
    loading,
    error,
    loadSettings,
    updateSettings,
  };
}
