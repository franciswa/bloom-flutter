import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { UserSettings } from '../types/database';

interface UseSettingsResult {
  settings: UserSettings | null;
  loading: boolean;
  error: string | null;
  saveSettings: (settings: Partial<UserSettings>) => Promise<void>;
  refreshSettings: () => Promise<void>;
}

export function useSettings(userId: string): UseSettingsResult {
  const [settings, setSettings] = useState<UserSettings | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadSettings = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const { data, error: fetchError } = await supabase
        .from('user_settings')
        .select('*')
        .eq('user_id', userId)
        .single();

      if (fetchError) throw fetchError;

      if (!data) {
        // Create default settings if none exist
        const defaultSettings: UserSettings = {
          id: crypto.randomUUID(),
          user_id: userId,
          theme_mode: 'light',
          dark_mode: false,
          notifications_enabled: true,
          notification_preferences: {
            matches: true,
            messages: true,
            date_reminders: true,
          },
          distance_range: 50,
          age_range_min: 18,
          age_range_max: 45,
          show_zodiac: true,
          show_birth_time: true,
          privacy_settings: {
            show_location: true,
            show_age: true,
            show_profile_photo: true,
          },
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        };

        const { error: insertError } = await supabase
          .from('user_settings')
          .insert(defaultSettings);

        if (insertError) throw insertError;
        setSettings(defaultSettings);
      } else {
        setSettings(data);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load settings');
    } finally {
      setLoading(false);
    }
  }, [userId]);

  const saveSettings = async (newSettings: Partial<UserSettings>) => {
    if (!settings) return;

    try {
      setError(null);
      const updatedSettings = {
        ...settings,
        ...newSettings,
        updated_at: new Date().toISOString(),
      };

      const { error: updateError } = await supabase
        .from('user_settings')
        .update(updatedSettings)
        .eq('id', settings.id);

      if (updateError) throw updateError;
      setSettings(updatedSettings);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save settings');
      throw err;
    }
  };

  // Subscribe to settings changes
  useEffect(() => {
    if (!userId) return;

    const channel = supabase
      .channel(`settings:${userId}`)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'user_settings',
          filter: `user_id=eq.${userId}`,
        },
        async (payload) => {
          if (payload.eventType === 'DELETE') {
            setSettings(null);
          } else {
            const newSettings = payload.new as UserSettings;
            setSettings(newSettings);
          }
        }
      )
      .subscribe();

    // Initial load
    loadSettings();

    return () => {
      channel.unsubscribe();
    };
  }, [userId, loadSettings]);

  return {
    settings,
    loading,
    error,
    saveSettings,
    refreshSettings: loadSettings,
  };
}
