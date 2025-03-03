import '../config/app_config.dart';
import '../models/astrology.dart';
import '../models/date_preference.dart';
import 'supabase_service.dart';

/// Date preference service
class DatePreferenceService {
  /// Table name
  static const String _tableName = AppConfig.supabaseDatePreferencesTable;

  /// Suggestions table name
  static const String _suggestionsTable =
      AppConfig.supabaseDateSuggestionsTable;

  /// Storage bucket name
  static const String _storageBucket =
      AppConfig.supabaseStorageDateSuggestionPhotosBucket;

  /// Get date preference by user ID
  Future<DatePreference?> getDatePreferenceByUserId(String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .filter('user_id', 'eq', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return DatePreference.fromJson(response);
  }

  /// Create date preference
  Future<DatePreference> createDatePreference(DatePreference preference) async {
    final response = await SupabaseService.from(_tableName)
        .insert(preference.toJson())
        .select()
        .single();

    return DatePreference.fromJson(response);
  }

  /// Update date preference
  Future<DatePreference> updateDatePreference(DatePreference preference) async {
    final response = await SupabaseService.from(_tableName)
        .update(preference.toJson())
        .filter('user_id', 'eq', preference.userId)
        .select()
        .single();

    return DatePreference.fromJson(response);
  }

  /// Delete date preference
  Future<void> deleteDatePreference(String userId) async {
    await SupabaseService.from(_tableName)
        .delete()
        .filter('user_id', 'eq', userId);
  }

  /// Create or update date preference
  Future<DatePreference> createOrUpdateDatePreference(
      DatePreference preference) async {
    final existingPreference =
        await getDatePreferenceByUserId(preference.userId);

    if (existingPreference != null) {
      return await updateDatePreference(preference);
    } else {
      return await createDatePreference(preference);
    }
  }

  /// Get date suggestion by ID
  Future<DateSuggestion?> getDateSuggestionById(String suggestionId) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .select()
        .filter('id', 'eq', suggestionId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return DateSuggestion.fromJson(response);
  }

  /// Get date suggestions by user ID
  Future<List<DateSuggestion>> getDateSuggestionsByUserId(String userId) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .select()
        .filter('user_id', 'eq', userId)
        .order('created_at', ascending: false);

    return response
        .map<DateSuggestion>((json) => DateSuggestion.fromJson(json))
        .toList();
  }

  /// Get date suggestions by match ID
  Future<List<DateSuggestion>> getDateSuggestionsByMatchId(
      String matchId) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .select()
        .filter('match_id', 'eq', matchId)
        .order('created_at', ascending: false);

    return response
        .map<DateSuggestion>((json) => DateSuggestion.fromJson(json))
        .toList();
  }

  /// Create date suggestion
  Future<DateSuggestion> createDateSuggestion(DateSuggestion suggestion) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .insert(suggestion.toJson())
        .select()
        .single();

    return DateSuggestion.fromJson(response);
  }

  /// Update date suggestion
  Future<DateSuggestion> updateDateSuggestion(DateSuggestion suggestion) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .update(suggestion.toJson())
        .filter('id', 'eq', suggestion.id)
        .select()
        .single();

    return DateSuggestion.fromJson(response);
  }

  /// Delete date suggestion
  Future<void> deleteDateSuggestion(String suggestionId) async {
    await SupabaseService.from(_suggestionsTable)
        .delete()
        .filter('id', 'eq', suggestionId);
  }

  /// Upload date suggestion photo
  Future<String> uploadDateSuggestionPhoto({
    required String suggestionId,
    required String filePath,
    required String fileName,
  }) async {
    final response = await SupabaseService.fromBucket(_storageBucket)
        .upload('$suggestionId/$fileName', filePath);

    return SupabaseService.fromBucket(_storageBucket).getPublicUrl(response);
  }

  /// Delete date suggestion photo
  Future<void> deleteDateSuggestionPhoto({
    required String suggestionId,
    required String fileName,
  }) async {
    await SupabaseService.fromBucket(_storageBucket)
        .remove(['$suggestionId/$fileName']);
  }

  /// Get date suggestions by type
  Future<List<DateSuggestion>> getDateSuggestionsByType(DateType type) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .select()
        .filter('type', 'eq', type.toString().split('.').last)
        .order('created_at', ascending: false);

    return response
        .map<DateSuggestion>((json) => DateSuggestion.fromJson(json))
        .toList();
  }

  /// Get date suggestions by location
  Future<List<DateSuggestion>> getDateSuggestionsByLocation({
    required double latitude,
    required double longitude,
    required double maxDistance,
  }) async {
    // In a real app, this would use PostGIS for location-based queries
    // For now, we'll return all suggestions
    final response = await SupabaseService.from(_suggestionsTable)
        .select()
        .order('created_at', ascending: false);

    return response
        .map<DateSuggestion>((json) => DateSuggestion.fromJson(json))
        .toList();
  }

  /// Get date suggestions by zodiac sign
  Future<List<DateSuggestion>> getDateSuggestionsByZodiacSign(
      ZodiacSign sign) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .select()
        .filter('zodiac_sign', 'eq', sign.toString().split('.').last)
        .order('created_at', ascending: false);

    return response
        .map<DateSuggestion>((json) => DateSuggestion.fromJson(json))
        .toList();
  }

  /// Get date suggestions by element
  Future<List<DateSuggestion>> getDateSuggestionsByElement(
      Element element) async {
    final response = await SupabaseService.from(_suggestionsTable)
        .select()
        .filter('element', 'eq', element.toString().split('.').last)
        .order('created_at', ascending: false);

    return response
        .map<DateSuggestion>((json) => DateSuggestion.fromJson(json))
        .toList();
  }

  /// Get recommended date suggestions
  Future<List<DateSuggestion>> getRecommendedDateSuggestions({
    required String userId,
    required String matchId,
    required ZodiacSign userSign,
    required ZodiacSign matchSign,
    required Element userElement,
    required Element matchElement,
    int limit = 5,
  }) async {
    // Get user date preferences
    final userPreference = await getDatePreferenceByUserId(userId);

    // Get all date suggestions
    final allSuggestions = await SupabaseService.from(_suggestionsTable)
        .select()
        .order('created_at', ascending: false);

    final suggestions = allSuggestions
        .map<DateSuggestion>((json) => DateSuggestion.fromJson(json))
        .toList();

    // Filter and score suggestions based on preferences and compatibility
    final scoredSuggestions = suggestions.map((suggestion) {
      int score = 50; // Base score

      // Increase score based on user preferences
      if (userPreference != null) {
        if (userPreference.preferredTypes.contains(suggestion.type)) {
          score += 20;
        }

        if (userPreference.preferredLocations.contains(suggestion.location)) {
          score += 15;
        }

        if (userPreference.preferredActivities.contains(suggestion.activity)) {
          score += 15;
        }
      }

      // Increase score based on zodiac sign compatibility
      if (suggestion.zodiacSign != null) {
        if (suggestion.zodiacSign == userSign ||
            suggestion.zodiacSign == matchSign) {
          score += 10;
        }
      }

      // Increase score based on element compatibility
      if (suggestion.element != null) {
        if (suggestion.element == userElement ||
            suggestion.element == matchElement) {
          score += 10;
        }
      }

      return (suggestion, score);
    }).toList();

    // Sort by score (descending) and take the top suggestions
    scoredSuggestions.sort((a, b) => b.$2.compareTo(a.$2));

    return scoredSuggestions.take(limit).map((scored) => scored.$1).toList();
  }

  /// Create date suggestion for match
  Future<DateSuggestion> createDateSuggestionForMatch({
    required String userId,
    required String matchId,
    required String matchedUserId,
    required DateType type,
    required String title,
    required String description,
    required String location,
    required String activity,
    ZodiacSign? zodiacSign,
    Element? element,
    String? imageUrl,
    DateTime? scheduledDate,
  }) async {
    return await createDateSuggestion(
      DateSuggestion(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        matchId: matchId,
        matchedUserId: matchedUserId,
        type: type,
        title: title,
        description: description,
        location: location,
        activity: activity,
        zodiacSign: zodiacSign,
        element: element,
        imageUrl: imageUrl,
        status: DateSuggestionStatus.pending,
        scheduledDate: scheduledDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Accept date suggestion
  Future<DateSuggestion> acceptDateSuggestion(String suggestionId) async {
    return await updateDateSuggestion(
      (await getDateSuggestionById(suggestionId))!.copyWith(
        status: DateSuggestionStatus.accepted,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Reject date suggestion
  Future<DateSuggestion> rejectDateSuggestion(String suggestionId) async {
    return await updateDateSuggestion(
      (await getDateSuggestionById(suggestionId))!.copyWith(
        status: DateSuggestionStatus.rejected,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Schedule date suggestion
  Future<DateSuggestion> scheduleDateSuggestion(
      String suggestionId, DateTime scheduledDate) async {
    final suggestion = await getDateSuggestionById(suggestionId);
    if (suggestion == null) {
      throw Exception('Date suggestion not found');
    }

    return await updateDateSuggestion(
      suggestion.copyWith(
        status: DateSuggestionStatus.scheduled,
        scheduledDate: () => scheduledDate,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Complete date suggestion
  Future<DateSuggestion> completeDateSuggestion(String suggestionId) async {
    return await updateDateSuggestion(
      (await getDateSuggestionById(suggestionId))!.copyWith(
        status: DateSuggestionStatus.completed,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Cancel date suggestion
  Future<DateSuggestion> cancelDateSuggestion(String suggestionId) async {
    return await updateDateSuggestion(
      (await getDateSuggestionById(suggestionId))!.copyWith(
        status: DateSuggestionStatus.cancelled,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
