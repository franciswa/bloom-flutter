import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/profile.dart';
import 'supabase_service.dart';

/// Profile service
class ProfileService {
  /// Table name
  static const String _tableName = AppConfig.supabaseProfilesTable;

  /// Storage bucket name
  static const String _storageBucket =
      AppConfig.supabaseStorageProfilePhotosBucket;

  /// Get profile by user ID
  Future<Profile?> getProfileByUserId(String userId) async {
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
    final response = await SupabaseService.from(_tableName)
        .insert(profile.toJson())
        .select()
        .single();

    return Profile.fromJson(response);
  }

  /// Update profile
  Future<Profile> updateProfile(Profile profile) async {
    final response = await SupabaseService.from(_tableName)
        .update(profile.toJson())
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
