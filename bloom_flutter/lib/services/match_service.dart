import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/match.dart';
import '../models/profile.dart';
import 'supabase_service.dart';

/// Match service
class MatchService {
  /// Table name
  static const String _tableName = AppConfig.supabaseMatchesTable;

  /// Get match by ID
  Future<Match?> getMatchById(String matchId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .filter('id', 'eq', matchId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Match.fromJson(response);
  }

  /// Get match by user IDs
  Future<Match?> getMatchByUserIds(String userId1, String userId2) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .or('first_user_id.eq.$userId1,first_user_id.eq.$userId2')
        .or('second_user_id.eq.$userId1,second_user_id.eq.$userId2')
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Match.fromJson(response);
  }

  /// Create match
  Future<Match> createMatch(Match match) async {
    final response = await SupabaseService.from(_tableName)
        .insert(match.toJson())
        .select()
        .single();

    return Match.fromJson(response);
  }

  /// Update match
  Future<Match> updateMatch(Match match) async {
    final response = await SupabaseService.from(_tableName)
        .update(match.toJson())
        .filter('id', 'eq', match.id)
        .select()
        .single();

    return Match.fromJson(response);
  }

  /// Delete match
  Future<void> deleteMatch(String matchId) async {
    await SupabaseService.from(_tableName)
        .delete()
        .filter('id', 'eq', matchId);
  }

  /// Get matches by user ID
  Future<List<Match>> getMatchesByUserId(String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .or('first_user_id.eq.$userId,second_user_id.eq.$userId')
        .order('updated_at', ascending: false);

    return response.map<Match>((json) => Match.fromJson(json)).toList();
  }

  /// Get matches by user ID and status
  Future<List<Match>> getMatchesByUserIdAndStatus(
    String userId,
    MatchStatus status,
  ) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .or('first_user_id.eq.$userId,second_user_id.eq.$userId')
        .filter('status', 'eq', status.toString().split('.').last)
        .order('updated_at', ascending: false);

    return response.map<Match>((json) => Match.fromJson(json)).toList();
  }

  /// Get pending matches by user ID
  Future<List<Match>> getPendingMatchesByUserId(String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .filter('second_user_id', 'eq', userId)
        .filter('status', 'eq', MatchStatus.pending.toString().split('.').last)
        .order('created_at', ascending: false);

    return response.map<Match>((json) => Match.fromJson(json)).toList();
  }

  /// Get active matches by user ID
  Future<List<Match>> getActiveMatchesByUserId(String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .or('first_user_id.eq.$userId,second_user_id.eq.$userId')
        .filter('status', 'eq', MatchStatus.matched.toString().split('.').last)
        .order('updated_at', ascending: false);

    return response.map<Match>((json) => Match.fromJson(json)).toList();
  }

  /// Like user
  Future<Match> likeUser(String currentUserId, String targetUserId) async {
    // Check if match already exists
    final existingMatch = await getMatchByUserIds(currentUserId, targetUserId);
    
    if (existingMatch != null) {
      // If current user is user1, update user1_action
      if (existingMatch.user1Id == currentUserId) {
        return await updateMatch(
          existingMatch.copyWith(
            user1Action: MatchAction.like,
            status: existingMatch.user2Action == MatchAction.like
                ? MatchStatus.matched
                : MatchStatus.pending,
            updatedAt: DateTime.now(),
          ),
        );
      }
      
      // If current user is user2, update user2_action
      if (existingMatch.user2Id == currentUserId) {
        return await updateMatch(
          existingMatch.copyWith(
            user2Action: MatchAction.like,
            status: existingMatch.user1Action == MatchAction.like
                ? MatchStatus.matched
                : MatchStatus.pending,
            updatedAt: DateTime.now(),
          ),
        );
      }
      
      throw Exception('Current user not found in match');
    }
    
    // Create new match
    return await createMatch(
      Match(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user1Id: currentUserId,
        user2Id: targetUserId,
        user1Action: MatchAction.like,
        user2Action: MatchAction.none,
        status: MatchStatus.pending,
        compatibilityScore: 0, // Will be updated by compatibility service
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Dislike user
  Future<Match> dislikeUser(String currentUserId, String targetUserId) async {
    // Check if match already exists
    final existingMatch = await getMatchByUserIds(currentUserId, targetUserId);
    
    if (existingMatch != null) {
      // If current user is user1, update user1_action
      if (existingMatch.user1Id == currentUserId) {
        return await updateMatch(
          existingMatch.copyWith(
            user1Action: MatchAction.dislike,
            status: MatchStatus.rejected,
            updatedAt: DateTime.now(),
          ),
        );
      }
      
      // If current user is user2, update user2_action
      if (existingMatch.user2Id == currentUserId) {
        return await updateMatch(
          existingMatch.copyWith(
            user2Action: MatchAction.dislike,
            status: MatchStatus.rejected,
            updatedAt: DateTime.now(),
          ),
        );
      }
      
      throw Exception('Current user not found in match');
    }
    
    // Create new match
    return await createMatch(
      Match(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user1Id: currentUserId,
        user2Id: targetUserId,
        user1Action: MatchAction.dislike,
        user2Action: MatchAction.none,
        status: MatchStatus.rejected,
        compatibilityScore: 0, // Will be updated by compatibility service
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Unmatch user
  Future<void> unmatchUser(String matchId) async {
    await updateMatch(
      (await getMatchById(matchId))!.copyWith(
        status: MatchStatus.unmatched,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Block user
  Future<void> blockUser(String matchId) async {
    await updateMatch(
      (await getMatchById(matchId))!.copyWith(
        status: MatchStatus.blocked,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Report user
  Future<void> reportUser(String matchId, String reason) async {
    await updateMatch(
      (await getMatchById(matchId))!.copyWith(
        status: MatchStatus.reported,
        reportReason: reason,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Get potential matches
  Future<List<Profile>> getPotentialMatches({
    required String userId,
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
    // Get profiles that match the criteria
    final response = await SupabaseService.from(AppConfig.supabaseProfilesTable)
        .select()
        .filter('user_id', 'neq', userId)
        .filter('is_profile_visible', 'eq', true)
        .filter('is_profile_complete', 'eq', true)
        .filter('birth_date', 'gte',
            DateTime.now().subtract(Duration(days: 365 * maxAge)).toIso8601String())
        .filter('birth_date', 'lte',
            DateTime.now().subtract(Duration(days: 365 * minAge)).toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    final profiles = response.map<Profile>((json) => Profile.fromJson(json)).toList();
    
    // Filter out profiles that have already been liked/disliked
    final existingMatches = await getMatchesByUserId(userId);
    final existingMatchUserIds = existingMatches
        .where((match) => 
            match.status == MatchStatus.rejected || 
            match.status == MatchStatus.blocked || 
            match.status == MatchStatus.reported)
        .map((match) => match.firstUserId == userId ? match.secondUserId : match.firstUserId)
        .toList();
    
    return profiles.where((profile) => !existingMatchUserIds.contains(profile.userId)).toList();
  }

  /// Get match stream
  Stream<List<Match>> getMatchStream(String userId) {
    return SupabaseService.client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .or('first_user_id.eq.$userId,second_user_id.eq.$userId')
        .order('updated_at')
        .map((events) => events.map<Match>((event) => Match.fromJson(event)).toList());
  }

  /// Subscribe to match changes
  RealtimeChannel subscribeToMatchChanges(
    String userId,
    void Function(Map<String, dynamic> payload) callback,
  ) {
    return SupabaseService.subscribeToTable(
      _tableName,
      filter: {'first_user_id': 'eq.$userId', 'second_user_id': 'eq.$userId'},
      callback: callback,
    );
  }
  
  /// Unsubscribe from match changes
  Future<void> unsubscribeFromMatchChanges(RealtimeChannel channel) async {
    await SupabaseService.unsubscribeFromTable(channel);
  }
}
