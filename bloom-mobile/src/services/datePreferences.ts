import { supabase } from '../lib/supabase';
import { ZodiacSign } from '../types/chart';

export type DateType = 'Dinner' | 'Coffee' | 'Drinks' | 'Games/Arcade' | 'Picnic' | 'Activity/Adventure' | 'Other/Anything';

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

export async function createDatePreference(
  desiredZodiac: ZodiacSign,
  dateType: DateType,
  preferredDate: Date
): Promise<DatePreference> {
  const { data: session } = await supabase.auth.getSession();
  if (!session?.session?.user) {
    throw new Error('User must be logged in to create date preferences');
  }

  const { data, error } = await supabase
    .from('date_preferences')
    .insert({
      user_id: session.session.user.id,
      desired_zodiac: desiredZodiac,
      date_type: dateType,
      preferred_date: preferredDate.toISOString().split('T')[0], // Format as YYYY-MM-DD
      status: 'pending',
    })
    .select()
    .single();

  if (error) throw error;
  if (!data) throw new Error('Failed to create date preference');

  return data;
}

export async function getUserDatePreferences(): Promise<DatePreference[]> {
  const { data: session } = await supabase.auth.getSession();
  if (!session?.session?.user) {
    throw new Error('User must be logged in to view date preferences');
  }

  const { data, error } = await supabase
    .from('date_preferences')
    .select('*')
    .eq('user_id', session.session.user.id)
    .order('created_at', { ascending: false });

  if (error) throw error;
  return data || [];
}

export async function cancelDatePreference(id: string): Promise<void> {
  const { data: session } = await supabase.auth.getSession();
  if (!session?.session?.user) {
    throw new Error('User must be logged in to cancel date preferences');
  }

  const { error } = await supabase
    .from('date_preferences')
    .update({ status: 'cancelled' })
    .eq('id', id)
    .eq('user_id', session.session.user.id);

  if (error) throw error;
}

export async function deleteDatePreference(id: string): Promise<void> {
  const { data: session } = await supabase.auth.getSession();
  if (!session?.session?.user) {
    throw new Error('User must be logged in to delete date preferences');
  }

  const { error } = await supabase
    .from('date_preferences')
    .delete()
    .eq('id', id)
    .eq('user_id', session.session.user.id);

  if (error) throw error;
}
