import { useState, useCallback } from 'react';
import { DatePreference, DateType, createDatePreference, getUserDatePreferences, cancelDatePreference, deleteDatePreference } from '../services/datePreferences';
import { ZodiacSign } from '../types/chart';

export function useDatePreferences() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [preferences, setPreferences] = useState<DatePreference[]>([]);

  const loadPreferences = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await getUserDatePreferences();
      setPreferences(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load date preferences');
    } finally {
      setLoading(false);
    }
  }, []);

  const createPreference = useCallback(async (
    zodiacSign: ZodiacSign,
    dateType: DateType,
    preferredDate: Date
  ) => {
    try {
      setLoading(true);
      setError(null);
      const newPreference = await createDatePreference(zodiacSign, dateType, preferredDate);
      setPreferences(prev => [newPreference, ...prev]);
      return newPreference;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to create date preference');
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  const cancelPreference = useCallback(async (id: string) => {
    try {
      setLoading(true);
      setError(null);
      await cancelDatePreference(id);
      setPreferences(prev => 
        prev.map(p => p.id === id ? { ...p, status: 'cancelled' } : p)
      );
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to cancel date preference');
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  const deletePreference = useCallback(async (id: string) => {
    try {
      setLoading(true);
      setError(null);
      await deleteDatePreference(id);
      setPreferences(prev => prev.filter(p => p.id !== id));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to delete date preference');
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  return {
    preferences,
    loading,
    error,
    loadPreferences,
    createPreference,
    cancelPreference,
    deletePreference,
  };
}
