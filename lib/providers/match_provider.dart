import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/match.dart';
import '../models/profile.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../services/service_registry.dart';

/// Match provider
class MatchProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Profile provider
  final ProfileProvider _profileProvider;

  /// Matches
  List<Match> _matches = [];

  /// Potential matches
  List<Profile> _potentialMatches = [];

  /// Active matches
  List<Match> _activeMatches = [];

  /// Pending matches
  List<Match> _pendingMatches = [];

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Realtime channel
  RealtimeChannel? _matchChannel;

  /// Creates a new [MatchProvider] instance
  MatchProvider({
    required AuthProvider authProvider,
    required ProfileProvider profileProvider,
  })  : _authProvider = authProvider,
        _profileProvider = profileProvider {
    _init();
  }

  /// Initialize
  Future<void> _init() async {
    if (_authProvider.currentUser == null || !_profileProvider.hasProfile) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _loadMatches();
      await _loadPotentialMatches();
      await _subscribeToMatchChanges();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load matches
  Future<void> _loadMatches() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _matches = await ServiceRegistry.matchService.getMatchesByUserId(userId);
    _activeMatches =
        await ServiceRegistry.matchService.getActiveMatchesByUserId(userId);
    _pendingMatches =
        await ServiceRegistry.matchService.getPendingMatchesByUserId(userId);
  }

  /// Load potential matches
  Future<void> _loadPotentialMatches() async {
    if (_authProvider.currentUser == null ||
        _profileProvider.currentProfile == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    final profile = _profileProvider.currentProfile!;

    _potentialMatches = await ServiceRegistry.matchService.getPotentialMatches(
      userId: userId,
      gender: profile.gender,
      lookingFor: profile.lookingFor,
      minAge: profile.minAgePreference,
      maxAge: profile.maxAgePreference,
      latitude: profile.currentLatitude ?? 0,
      longitude: profile.currentLongitude ?? 0,
      maxDistance: profile.maxDistancePreference,
    );
  }

  /// Subscribe to match changes
  Future<void> _subscribeToMatchChanges() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;

    // Unsubscribe from previous channel if exists
    if (_matchChannel != null) {
      await ServiceRegistry.matchService
          .unsubscribeFromMatchChanges(_matchChannel!);
    }

    // Subscribe to match changes
    _matchChannel = ServiceRegistry.matchService.subscribeToMatchChanges(
      userId,
      (payload) async {
        await _loadMatches();
        notifyListeners();
      },
    );
  }

  /// Update auth provider
  void updateAuthProvider({required AuthProvider authProvider}) {
    if (_authProvider.currentUser?.id != authProvider.currentUser?.id) {
      _init();
    }
  }

  /// Update profile provider
  void updateProfileProvider({required ProfileProvider profileProvider}) {
    if (_profileProvider.currentProfile?.userId !=
        profileProvider.currentProfile?.userId) {
      _init();
    }
  }

  /// Get matches
  List<Match> get matches => _matches;

  /// Get potential matches
  List<Profile> get potentialMatches => _potentialMatches;

  /// Get active matches
  List<Match> get activeMatches => _activeMatches;

  /// Get pending matches
  List<Match> get pendingMatches => _pendingMatches;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Like user
  Future<void> likeUser(String targetUserId) async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;
      final match =
          await ServiceRegistry.matchService.likeUser(userId, targetUserId);

      // If it's a new match, add it to the matches list
      if (!_matches.any((m) => m.id == match.id)) {
        _matches.add(match);
      } else {
        // Otherwise, update the existing match
        final index = _matches.indexWhere((m) => m.id == match.id);
        if (index != -1) {
          _matches[index] = match;
        }
      }

      // If it's a new active match, add it to the active matches list
      if (match.status == MatchStatus.matched &&
          !_activeMatches.any((m) => m.id == match.id)) {
        _activeMatches.add(match);
      }

      // Remove from potential matches
      _potentialMatches
          .removeWhere((profile) => profile.userId == targetUserId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Dislike user
  Future<void> dislikeUser(String targetUserId) async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;
      final match =
          await ServiceRegistry.matchService.dislikeUser(userId, targetUserId);

      // If it's a new match, add it to the matches list
      if (!_matches.any((m) => m.id == match.id)) {
        _matches.add(match);
      } else {
        // Otherwise, update the existing match
        final index = _matches.indexWhere((m) => m.id == match.id);
        if (index != -1) {
          _matches[index] = match;
        }
      }

      // Remove from potential matches
      _potentialMatches
          .removeWhere((profile) => profile.userId == targetUserId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Unmatch user
  Future<void> unmatchUser(String matchId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.matchService.unmatchUser(matchId);

      // Update match status in matches list
      final index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _matches[index] = _matches[index].copyWith(
          status: MatchStatus.unmatched,
          updatedAt: DateTime.now(),
        );
      }

      // Remove from active matches
      _activeMatches.removeWhere((m) => m.id == matchId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Block user
  Future<void> blockUser(String matchId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.matchService.blockUser(matchId);

      // Update match status in matches list
      final index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _matches[index] = _matches[index].copyWith(
          status: MatchStatus.blocked,
          updatedAt: DateTime.now(),
        );
      }

      // Remove from active matches
      _activeMatches.removeWhere((m) => m.id == matchId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Report user
  Future<void> reportUser(String matchId, String reason) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.matchService.reportUser(matchId, reason);

      // Update match status in matches list
      final index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _matches[index] = _matches[index].copyWith(
          status: MatchStatus.reported,
          reportReason: () => reason,
          updatedAt: DateTime.now(),
        );
      }

      // Remove from active matches
      _activeMatches.removeWhere((m) => m.id == matchId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get match by ID
  Match? getMatchById(String matchId) {
    return _matches.firstWhere((m) => m.id == matchId);
  }

  /// Get match by user ID
  Match? getMatchByUserId(String userId) {
    if (_authProvider.currentUser == null) {
      return null;
    }

    final currentUserId = _authProvider.currentUser!.id;
    try {
      return _matches.firstWhere(
        (m) =>
            (m.user1Id == currentUserId && m.user2Id == userId) ||
            (m.user1Id == userId && m.user2Id == currentUserId),
      );
    } catch (e) {
      return null;
    }
  }

  /// Refresh matches
  Future<void> refreshMatches() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadMatches();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh potential matches
  Future<void> refreshPotentialMatches() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadPotentialMatches();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Dispose
  @override
  void dispose() {
    if (_matchChannel != null) {
      ServiceRegistry.matchService.unsubscribeFromMatchChanges(_matchChannel!);
    }
    super.dispose();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
