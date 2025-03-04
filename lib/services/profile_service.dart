import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/astrology.dart';
import '../models/profile.dart';
import 'auth_service.dart' show isDemoMode;
import 'supabase_service.dart';

/// Profile service
class ProfileService {
  /// Table name
  static const String _tableName = AppConfig.supabaseProfilesTable;

  /// Storage bucket name
  static const String _storageBucket =
      AppConfig.supabaseStorageProfilePhotosBucket;

  /// Demo profile for testing
  final Profile _demoProfile = Profile(
    userId: 'demo-user-123',
    displayName: 'cosmic_voyager',
    firstName: 'Alex',
    lastName: 'Thompson',
    birthDate: DateTime(1990, 4, 15),
    birthTime: '08:30',
    birthCity: 'Los Angeles',
    birthCountry: 'USA',
    birthLocation: 'Los Angeles, USA',
    birthLatitude: 34.0522,
    birthLongitude: -118.2437,
    currentLocation: 'San Francisco, USA',
    currentLatitude: 37.7749,
    currentLongitude: -122.4194,
    bio:
        'Passionate about astrology, music, and hiking. Looking for someone who shares my love for adventure!',
    gender: Gender.nonBinary,
    zodiacSign: ZodiacSign.aries,
    lookingFor: LookingFor.everyone,
    minAgePreference: 21,
    maxAgePreference: 35,
    maxDistancePreference: 50.0,
    profilePhotoUrl:
        'https://fastly.picsum.photos/id/64/200/200.jpg?hmac=lkxq4I3coqHlG_MQZhW_pJU3N5-XAPA0Ivs6lQwoJ2U',
    photoUrls: [
      'https://fastly.picsum.photos/id/64/200/200.jpg?hmac=lkxq4I3coqHlG_MQZhW_pJU3N5-XAPA0Ivs6lQwoJ2U',
      'https://fastly.picsum.photos/id/823/200/200.jpg?hmac=QTpYty9IBJGX9uBmFJ9qdyxw0Mf3JIoLSjbWaLSKJGE',
      'https://fastly.picsum.photos/id/177/200/200.jpg?hmac=Js5Un_xgrw5Xlv2XgP0_RpzzPZvgGHjGR5s1HpLq9OE'
    ],
    isProfileComplete: true,
    isProfileVisible: true,
    isOnline: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  /// Get profile by user ID
  Future<Profile?> getProfileByUserId(String userId) async {
    // Return demo profile if in demo mode
    if (isDemoMode && userId == 'demo-user-123') {
      return _demoProfile;
    }

    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Profile.fromJson(response);
  }

  /// Get user profile (alias for getProfileByUserId)
  Future<Profile?> getUserProfile(String userId) async {
    return getProfileByUserId(userId);
  }

  /// Create profile
  Future<Profile> createProfile(Profile profile) async {
    // Return demo profile if in demo mode
    if (isDemoMode) {
      return _demoProfile;
    }

    // Convert profile to JSON
    final json = profile.toJson();

    // Remove 'bio' field if it exists to avoid database schema issues
    json.remove('bio');

    final response =
        await SupabaseService.from(_tableName).insert(json).select().single();

    return Profile.fromJson(response);
  }

  /// Update profile
  Future<Profile> updateProfile(Profile profile) async {
    // Return demo profile if in demo mode
    if (isDemoMode) {
      return _demoProfile;
    }

    // Convert profile to JSON
    final json = profile.toJson();

    // Remove 'bio' field if it exists to avoid database schema issues
    json.remove('bio');

    final response = await SupabaseService.from(_tableName)
        .update(json)
        .eq('user_id', profile.userId)
        .select()
        .single();

    return Profile.fromJson(response);
  }

  /// Delete profile
  Future<void> deleteProfile(String userId) async {
    await SupabaseService.from(_tableName).delete().eq('user_id', userId);
  }

  /// Upload profile photo
  Future<String> uploadProfilePhoto({
    required String userId,
    required String filePath,
    required String fileName,
  }) async {
    final response = await SupabaseService.fromBucket(_storageBucket)
        .upload('$userId/$fileName', filePath);

    return SupabaseService.fromBucket(_storageBucket).getPublicUrl(response);
  }

  /// Delete profile photo
  Future<void> deleteProfilePhoto({
    required String userId,
    required String fileName,
  }) async {
    await SupabaseService.fromBucket(_storageBucket)
        .remove(['$userId/$fileName']);
  }

  /// Get profiles by IDs
  Future<List<Profile>> getProfilesByIds(List<String> userIds) async {
    final response =
        await SupabaseService.from(_tableName).select().in_('user_id', userIds);

    return response.map<Profile>((json) => Profile.fromJson(json)).toList();
  }

  /// Search profiles
  Future<List<Profile>> searchProfiles({
    required Gender gender,
    required LookingFor lookingFor,
    required int minAge,
    required int maxAge,
    required double latitude,
    required double longitude,
    required double maxDistance,
    int limit = 20,
    int offset = 0,
  }) async {
    // Return demo profiles if in demo mode
    if (isDemoMode) {
      // Create some mock profiles for demo purposes
      return [
        _demoProfile,
        Profile(
          userId: 'demo-user-124',
          displayName: 'star_gazer',
          firstName: 'Jamie',
          lastName: 'Morgan',
          birthDate: DateTime(1992, 7, 22),
          birthTime: '14:15',
          birthCity: 'Austin',
          birthCountry: 'USA',
          birthLocation: 'Austin, USA',
          birthLatitude: 30.2672,
          birthLongitude: -97.7431,
          currentLocation: 'Austin, USA',
          currentLatitude: 30.2672,
          currentLongitude: -97.7431,
          bio:
              'Astrology enthusiast and yoga instructor. Looking for meaningful connections.',
          gender: Gender.female,
          zodiacSign: ZodiacSign.cancer,
          lookingFor: LookingFor.everyone,
          minAgePreference: 25,
          maxAgePreference: 40,
          maxDistancePreference: 30.0,
          profilePhotoUrl:
              'https://fastly.picsum.photos/id/445/200/200.jpg?hmac=IJG-gf_9T2Gtg2KexrKopq8DiJt20fX2PoMpIvjZsAE',
          photoUrls: [
            'https://fastly.picsum.photos/id/445/200/200.jpg?hmac=IJG-gf_9T2Gtg2KexrKopq8DiJt20fX2PoMpIvjZsAE',
            'https://fastly.picsum.photos/id/237/200/200.jpg?hmac=zHUGikXUDyLCCmvyww1izLK3R3k8tgL1tzIOQkzdsaA'
          ],
          isProfileComplete: true,
          isProfileVisible: true,
          isOnline: true,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        ),
        Profile(
          userId: 'demo-user-125',
          displayName: 'zodiac_lover',
          firstName: 'Taylor',
          lastName: 'Kim',
          birthDate: DateTime(1995, 11, 3),
          birthTime: '23:45',
          birthCity: 'Seattle',
          birthCountry: 'USA',
          birthLocation: 'Seattle, USA',
          birthLatitude: 47.6062,
          birthLongitude: -122.3321,
          currentLocation: 'Portland, USA',
          currentLatitude: 45.5152,
          currentLongitude: -122.6784,
          bio:
              'Scorpio with Taurus rising. I love hiking, photography and deep conversations.',
          gender: Gender.nonBinary,
          zodiacSign: ZodiacSign.scorpio,
          lookingFor: LookingFor.everyone,
          minAgePreference: 21,
          maxAgePreference: 35,
          maxDistancePreference: 100.0,
          profilePhotoUrl:
              'https://fastly.picsum.photos/id/338/200/200.jpg?hmac=5S-rifIZ1QGcJWUYJZV1hXBGpkQVqOr_slDQY2GeAVM',
          photoUrls: [
            'https://fastly.picsum.photos/id/338/200/200.jpg?hmac=5S-rifIZ1QGcJWUYJZV1hXBGpkQVqOr_slDQY2GeAVM',
            'https://fastly.picsum.photos/id/669/200/200.jpg?hmac=R3yHODj0ESwfEkwpTjU8d4IQCzTU-cEH1X2q9v2zyqA'
          ],
          isProfileComplete: true,
          isProfileVisible: true,
          isOnline: false,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        )
      ];
    }

    // This is a simplified version of the search query
    // In a real app, you would use PostGIS for location-based queries
    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('gender', gender.toString().split('.').last)
        .eq('is_profile_visible', true)
        .eq('is_profile_complete', true)
        .gte(
            'birth_date',
            DateTime.now()
                .subtract(Duration(days: 365 * maxAge))
                .toIso8601String())
        .lte(
            'birth_date',
            DateTime.now()
                .subtract(Duration(days: 365 * minAge))
                .toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    return response.map<Profile>((json) => Profile.fromJson(json)).toList();
  }

  /// Get profile stream
  Stream<Profile> getProfileStream(String userId) {
    return SupabaseService.client
        .from(_tableName)
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((event) => Profile.fromJson(event.first));
  }

  /// Check if display name is available
  Future<bool> isDisplayNameAvailable(String displayName) async {
    final response = await SupabaseService.from(_tableName)
        .select('display_name')
        .eq('display_name', displayName);

    return response.isEmpty;
  }

  /// Get profile by display name
  Future<Profile?> getProfileByDisplayName(String displayName) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('display_name', displayName)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Profile.fromJson(response);
  }

  /// Update profile visibility
  Future<void> updateProfileVisibility({
    required String userId,
    required bool isVisible,
  }) async {
    await SupabaseService.from(_tableName)
        .update({'is_profile_visible': isVisible}).eq('user_id', userId);
  }

  /// Update current location
  Future<void> updateCurrentLocation({
    required String userId,
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    await SupabaseService.from(_tableName).update({
      'current_location': location,
      'current_latitude': latitude,
      'current_longitude': longitude,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('user_id', userId);
  }

  /// Get nearby profiles
  Future<List<Profile>> getNearbyProfiles({
    required String userId,
    required double latitude,
    required double longitude,
    required double maxDistance,
    required Gender gender,
    required LookingFor lookingFor,
    required int minAge,
    required int maxAge,
    int limit = 20,
    int offset = 0,
  }) async {
    // This is a simplified version of the nearby query
    // In a real app, you would use PostGIS for location-based queries
    final response = await SupabaseService.from(_tableName)
        .select()
        .neq('user_id', userId)
        .eq('gender', gender.toString().split('.').last)
        .eq('is_profile_visible', true)
        .eq('is_profile_complete', true)
        .gte(
            'birth_date',
            DateTime.now()
                .subtract(Duration(days: 365 * maxAge))
                .toIso8601String())
        .lte(
            'birth_date',
            DateTime.now()
                .subtract(Duration(days: 365 * minAge))
                .toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    return response.map<Profile>((json) => Profile.fromJson(json)).toList();
  }

  /// Get recommended profiles
  Future<List<Profile>> getRecommendedProfiles({
    required String userId,
    required Gender gender,
    required LookingFor lookingFor,
    required int minAge,
    required int maxAge,
    int limit = 20,
    int offset = 0,
  }) async {
    // This is a simplified version of the recommended query
    // In a real app, you would use a more sophisticated recommendation algorithm
    final response = await SupabaseService.from(_tableName)
        .select()
        .neq('user_id', userId)
        .eq('gender', gender.toString().split('.').last)
        .eq('is_profile_visible', true)
        .eq('is_profile_complete', true)
        .gte(
            'birth_date',
            DateTime.now()
                .subtract(Duration(days: 365 * maxAge))
                .toIso8601String())
        .lte(
            'birth_date',
            DateTime.now()
                .subtract(Duration(days: 365 * minAge))
                .toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    return response.map<Profile>((json) => Profile.fromJson(json)).toList();
  }

  /// Subscribe to profile changes
  RealtimeChannel subscribeToProfileChanges(
    String userId,
    void Function(Map<String, dynamic> payload) callback,
  ) {
    return SupabaseService.subscribeToTable(
      _tableName,
      filter: {'user_id': 'eq.$userId'},
      callback: callback,
    );
  }

  /// Unsubscribe from profile changes
  Future<void> unsubscribeFromProfileChanges(RealtimeChannel channel) async {
    await SupabaseService.unsubscribeFromTable(channel);
  }
}
