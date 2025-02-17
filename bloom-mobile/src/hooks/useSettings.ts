import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { UserSettings, ThemeMode } from '../types/database';

export interface UseSettingsResult {
  settings: UserSettings | null;
  loading: boolean;
  error: string | null;
  updateThemeMode: (mode: ThemeMode) => Promise<void>;
  updateNotificationPreferences: (preferences: {
    matches?: boolean;
    messages?: boolean;
    date_reminders?: boolean;
  }) => Promise<void>;
  updateSettings: (updates: Partial<Omit<UserSettings, 'id' | 'user_id' | 'created_at' | 'updated_at'>>) => Promise<void>;
}

export function useSettings(): UseSettingsResult {
  const [settings, setSettings] = useState<UserSettings | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchSettings = useCallback(async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        setSettings(null);
        setLoading(false);
        return;
      }

      const { data, error: dbError } = await supabase
        .from('user_settings')
        .select('*')
        .eq('user_id', user.id)
        .single();

      if (dbError) throw dbError;

      if (!data) {
        // Create default settings if none exist
        const defaultSettings: Omit<UserSettings, 'id' | 'created_at' | 'updated_at'> = {
          user_id: user.id,
          theme_mode: 'system',
          dark_mode: false,
          notifications_enabled: true,
          notification_preferences: {
            matches: true,
            messages: true,
            date_reminders: true,
          },
          distance_range: 50, // 50 miles/km default
          age_range_min: 18,
          age_range_max: 99,
          show_zodiac: true,
          show_birth_time: true,
          privacy_settings: {
            show_location: true,
            show_age: true,
            show_profile_photo: true,
          },
        };

        const { data: newSettings, error: insertError } = await supabase
          .from('user_settings')
          .insert(defaultSettings)
          .select()
          .single();

        if (insertError) throw insertError;

        setSettings(newSettings);
      } else {
        setSettings(data);
      }

      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load settings');
      console.error('Error loading settings:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  const updateThemeMode = useCallback(async (mode: ThemeMode) => {
    if (!settings) return;

    try {
      const { error: dbError } = await supabase
        .from('user_settings')
        .update({ theme_mode: mode })
        .eq('id', settings.id);

      if (dbError) throw dbError;

      setSettings(prev => prev ? { ...prev, theme_mode: mode } : null);
    } catch (err) {
      console.error('Error updating theme mode:', err);
      throw err;
    }
  }, [settings]);

  const updateNotificationPreferences = useCallback(async (preferences: {
    matches?: boolean;
    messages?: boolean;
    date_reminders?: boolean;
  }) => {
    if (!settings) return;

    try {
      const updatedPreferences = {
        ...settings.notification_preferences,
        ...preferences,
      };

      const { error: dbError } = await supabase
        .from('user_settings')
        .update({ notification_preferences: updatedPreferences })
        .eq('id', settings.id);

      if (dbError) throw dbError;

      setSettings(prev => prev ? {
        ...prev,
        notification_preferences: updatedPreferences,
      } : null);
    } catch (err) {
      console.error('Error updating notification preferences:', err);
      throw err;
    }
  }, [settings]);

  const updateSettings = useCallback(async (updates: Partial<Omit<UserSettings, 'id' | 'user_id' | 'created_at' | 'updated_at'>>) => {
    if (!settings) return;

    try {
      const { error: dbError } = await supabase
        .from('user_settings')
        .update(updates)
        .eq('id', settings.id);

      if (dbError) throw dbError;

      setSettings(prev => prev ? { ...prev, ...updates } : null);
    } catch (err) {
      console.error('Error updating settings:', err);
      throw err;
    }
  }, [settings]);

  // Subscribe to settings changes
  useEffect(() => {
    const setupSubscription = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const subscription = supabase
        .channel('settings_changes')
        .on(
          'postgres_changes',
          {
            event: '*',
            schema: 'public',
            table: 'user_settings',
            filter: `user_id=eq.${user.id}`,
          },
          async () => {
            await fetchSettings();
          }
        )
        .subscribe();

      return () => {
        subscription.unsubscribe();
      };
    };

    setupSubscription();
  }, [fetchSettings]);

  // Initial fetch
  useEffect(() => {
    fetchSettings();
  }, [fetchSettings]);

  return {
    settings,
    loading,
    error,
    updateThemeMode,
    updateNotificationPreferences,
    updateSettings,
  };
}
