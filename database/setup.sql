-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Create profiles table
create table profiles (
  id uuid references auth.users primary key,
  email text,
  birth_date date,
  location_city text,
  dinner_location text,
  country text,
  industry text,
  has_children text,
  relationship_status text,
  gender_identity text,
  personality_ratings jsonb,
  lifestyle_ratings jsonb,
  values_ratings jsonb,
  entertainment_preference text,
  self_perception text,
  movie_preference text,
  decision_style text,
  planning_style text,
  fashion_style text,
  questionnaire_completed boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create user_settings table
create table user_settings (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references profiles(id) unique,
  settings jsonb not null default '{
    "notifications_enabled": true,
    "dark_mode": true,
    "distance_range": 50,
    "age_range_min": 18,
    "age_range_max": 35,
    "show_zodiac": true,
    "show_birth_time": true,
    "preferred_date_types": ["Dinner", "Coffee", "Drinks"]
  }'::jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create date_preferences table
create table date_preferences (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references profiles(id),
  desired_zodiac text not null,
  date_type text not null,
  preferred_date date not null,
  status text default 'pending',
  created_at timestamp with time zone default timezone('utc'::text, now()),
  updated_at timestamp with time zone default timezone('utc'::text, now()),
  constraint valid_date_type check (
    date_type in ('Dinner', 'Coffee', 'Drinks', 'Games/Arcade', 'Picnic', 'Activity/Adventure', 'Other/Anything')
  ),
  constraint valid_status check (
    status in ('pending', 'matching', 'matched', 'completed', 'cancelled', 'expired')
  ),
  constraint max_active_dates check (
    (select count(*) from date_preferences dp 
     where dp.user_id = date_preferences.user_id 
     and dp.status in ('pending', 'matching', 'matched')) <= 3
  )
);

-- Create notifications table
create table notifications (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references profiles(id),
  type text not null,
  content jsonb not null,
  read boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  constraint valid_notification_type check (
    type in ('match_found', 'match_accepted', 'match_cancelled', 'date_reminder')
  )
);

-- Add indexes for notifications
create index idx_notifications_user on notifications(user_id);
create index idx_notifications_created_at on notifications(created_at);
create index idx_notifications_read on notifications(read);

-- Add RLS for notifications
alter table notifications enable row level security;

create policy "Users can view their own notifications"
  on notifications for select
  using (auth.uid() = user_id);

create policy "System can create notifications"
  on notifications for insert
  with check (true);

create policy "Users can update their own notifications"
  on notifications for update
  using (auth.uid() = user_id);

-- Add trigger to update date_preferences updated_at
create or replace function update_date_preferences_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$ language plpgsql;

create trigger update_date_preferences_updated_at
  before update on date_preferences
  for each row
  execute function update_date_preferences_updated_at();

-- Enable realtime for notifications
alter publication supabase_realtime add table notifications;

-- Create matches table
create table matches (
  id uuid default uuid_generate_v4() primary key,
  user1_id uuid references profiles(id),
  user2_id uuid references profiles(id),
  date_preference_id uuid references date_preferences(id),
  compatibility_score float,
  astrological_score float,
  questionnaire_score float,
  status text default 'pending',
  match_date date,
  date_type text,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  constraint max_active_matches_user1 check (
    (select count(*) from matches m 
     where m.user1_id = matches.user1_id 
     and m.status = 'accepted') <= 3
  ),
  constraint max_active_matches_user2 check (
    (select count(*) from matches m 
     where m.user2_id = matches.user2_id 
     and m.status = 'accepted') <= 3
  )
);

-- Create messages table
create table messages (
  id uuid default uuid_generate_v4() primary key,
  match_id uuid references matches(id),
  sender_id uuid references profiles(id),
  content text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Create indexes for better query performance
create index idx_profiles_questionnaire on profiles(questionnaire_completed);
create index idx_matches_users on matches(user1_id, user2_id);
create index idx_matches_status on matches(status);
create index idx_messages_match on messages(match_id);
create index idx_messages_created_at on messages(created_at);
create index idx_date_preferences_user on date_preferences(user_id);
create index idx_date_preferences_status on date_preferences(status);
create index idx_date_preferences_zodiac on date_preferences(desired_zodiac);
create index idx_date_preferences_date on date_preferences(preferred_date);
create index idx_user_settings_user on user_settings(user_id);

-- Set up Row Level Security (RLS)
alter table profiles enable row level security;
alter table matches enable row level security;
alter table messages enable row level security;
alter table date_preferences enable row level security;
alter table user_settings enable row level security;

-- Profiles policies
create policy "Public profiles are viewable by everyone"
  on profiles for select
  using (true);

create policy "Users can insert their own profile"
  on profiles for insert
  with check (auth.uid() = id);

create policy "Users can update own profile"
  on profiles for update using (auth.uid() = id);

-- User settings policies
create policy "Users can view their own settings"
  on user_settings for select
  using (auth.uid() = user_id);

create policy "Users can insert their own settings"
  on user_settings for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own settings"
  on user_settings for update
  using (auth.uid() = user_id);

-- Date preferences policies
create policy "Users can view their own date preferences"
  on date_preferences for select
  using (auth.uid() = user_id);

create policy "Users can create date preferences if under limit"
  on date_preferences for insert
  with check (
    auth.uid() = user_id and
    (select count(*) from date_preferences 
     where user_id = auth.uid() 
     and status in ('pending', 'matched')) < 3
  );

create policy "Users can update their own date preferences"
  on date_preferences for update
  using (auth.uid() = user_id);

create policy "Users can delete their own date preferences"
  on date_preferences for delete
  using (auth.uid() = user_id);

-- Matches policies
create policy "Users can view their own matches"
  on matches for select
  using (auth.uid() = user1_id or auth.uid() = user2_id);

create policy "Users can create matches if under limit"
  on matches for insert
  with check (
    auth.uid() = user1_id and
    (select count(*) from matches 
     where (user1_id = auth.uid() or user2_id = auth.uid())
     and status = 'accepted') < 3
  );

create policy "Users can update their own matches"
  on matches for update
  using (auth.uid() = user1_id or auth.uid() = user2_id);

-- Messages policies
create policy "Match participants can view messages"
  on messages for select
  using (
    auth.uid() in (
      select user1_id from matches where id = match_id
      union
      select user2_id from matches where id = match_id
    )
  );

create policy "Match participants can insert messages"
  on messages for insert
  with check (
    auth.uid() = sender_id and
    auth.uid() in (
      select user1_id from matches where id = match_id
      union
      select user2_id from matches where id = match_id
    )
  );

-- Create function to handle user creation
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  
  -- Also create default settings for the new user
  insert into public.user_settings (user_id)
  values (new.id);
  
  return new;
end;
$$ language plpgsql security definer;

-- Create trigger for new user creation
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Enable realtime for messages, date_preferences, and user_settings
alter publication supabase_realtime add table messages;
alter publication supabase_realtime add table date_preferences;
alter publication supabase_realtime add table user_settings;
