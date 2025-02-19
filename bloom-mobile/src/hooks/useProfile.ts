import { useState, useCallback } from 'react';
import * as ImagePicker from 'expo-image-picker';
import { Profile } from '../types/database';
import { NatalChartData, calculateNatalChart } from '../services/astrological';

interface UseProfileResult {
  profile: Profile | null;
  loading: boolean;
  error: string | null;
  uploadPhoto: () => Promise<void>;
  updateNatalChart: (birthInfo: {
    date: string;
    time: string;
    latitude: number;
    longitude: number;
  }) => Promise<void>;
  updateQuestionnaireData: (data: {
    personality: Record<string, number>;
    lifestyle: Record<string, number>;
    values: Record<string, number>;
  }) => Promise<void>;
}

export function useProfile(userId: string): UseProfileResult {
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Load profile data
  const loadProfile = useCallback(async () => {
    try {
      setLoading(true);
      // TODO: Fetch profile from database
      // const response = await supabase.from('profiles').select('*').eq('id', userId).single();
      // setProfile(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load profile');
    } finally {
      setLoading(false);
    }
  }, [userId]);

  // Handle photo upload
  const uploadPhoto = useCallback(async () => {
    try {
      // Request permissions
      const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();
      if (!permissionResult.granted) {
        throw new Error('Permission to access camera roll was denied');
      }

      // Launch image picker
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images,
        allowsEditing: true,
        aspect: [1, 1],
        quality: 0.8,
      });

      if (!result.canceled) {
        const photoUri = result.assets[0].uri;
        
        // TODO: Upload photo to storage
        // const { data, error } = await supabase.storage
        //   .from('profile-photos')
        //   .upload(`${userId}/${new Date().getTime()}.jpg`, photoUri);

        // TODO: Update profile photos array in database
        // const photoUrl = data?.path ? `${STORAGE_URL}/${data.path}` : '';
        // const updatedPhotos = [...(profile?.photos || []), {
        //   id: new Date().getTime().toString(),
        //   url: photoUrl,
        //   is_primary: profile?.photos.length === 0,
        //   uploaded_at: new Date().toISOString()
        // }];
        
        // await supabase.from('profiles')
        //   .update({ photos: updatedPhotos })
        //   .eq('id', userId);

        // await loadProfile();
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to upload photo');
    }
  }, [userId, profile]);

  // Update natal chart
  const updateNatalChart = useCallback(async (birthInfo: {
    date: string;
    time: string;
    latitude: number;
    longitude: number;
  }) => {
    try {
      const natalChart = await calculateNatalChart(birthInfo);
      
      // TODO: Update profile in database
      // await supabase.from('profiles').update({
      //   birth_date: birthInfo.date,
      //   birth_time: birthInfo.time,
      //   birth_location: {
      //     city: 'TODO: Reverse geocode from lat/lng',
      //     latitude: birthInfo.latitude,
      //     longitude: birthInfo.longitude
      //   },
      //   natal_chart: natalChart
      // }).eq('id', userId);

      // await loadProfile();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update natal chart');
    }
  }, [userId]);

  // Update questionnaire data
  const updateQuestionnaireData = useCallback(async (data: {
    personality: Record<string, number>;
    lifestyle: Record<string, number>;
    values: Record<string, number>;
  }) => {
    try {
      // TODO: Update profile in database
      // await supabase.from('profiles').update({
      //   personality_ratings: data.personality,
      //   lifestyle_ratings: data.lifestyle,
      //   values_ratings: data.values
      // }).eq('id', userId);

      // await loadProfile();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update questionnaire data');
    }
  }, [userId]);

  return {
    profile,
    loading,
    error,
    uploadPhoto,
    updateNatalChart,
    updateQuestionnaireData
  };
}
