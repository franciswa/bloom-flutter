import 'package:flutter/foundation.dart';

import '../models/chart.dart';
import '../models/compatibility.dart';
import '../models/profile.dart';
import '../providers/auth_provider.dart';
import '../providers/chart_provider.dart';
import '../providers/profile_provider.dart';
import '../services/service_registry.dart';

/// Compatibility provider
class CompatibilityProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Profile provider
  final ProfileProvider _profileProvider;

  /// Chart provider
  final ChartProvider _chartProvider;

  /// Compatibilities
  final Map<String, Compatibility> _compatibilities = {};

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Creates a new [CompatibilityProvider] instance
  CompatibilityProvider({
    required AuthProvider authProvider,
    required ProfileProvider profileProvider,
    required ChartProvider chartProvider,
  })  : _authProvider = authProvider,
        _profileProvider = profileProvider,
        _chartProvider = chartProvider;

  /// Get compatibility by user ID
  Future<Compatibility?> getCompatibilityByUserId(String userId) async {
    // Return from cache if available
    if (_compatibilities.containsKey(userId)) {
      return _compatibilities[userId];
    }

    if (_authProvider.currentUser == null || !_chartProvider.hasChart) {
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final currentUserId = _authProvider.currentUser!.id;

      // Get compatibility from service
      final compatibility =
          await ServiceRegistry.compatibilityService.getCompatibilityByUserIds(
        currentUserId,
        userId,
      );

      // If compatibility exists, cache it
      if (compatibility != null) {
        _compatibilities[userId] = compatibility;
        _errorMessage = null;
        return compatibility;
      }

      // If compatibility doesn't exist, calculate it using user IDs
      final newCompatibility =
          await ServiceRegistry.compatibilityService.calculateCompatibility(
        currentUserId,
        userId,
      );

      // Cache compatibility
      _compatibilities[userId] = newCompatibility;
      _errorMessage = null;
      return newCompatibility;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get compatibility score by user ID
  Future<int?> getCompatibilityScoreByUserId(String userId) async {
    final compatibility = await getCompatibilityByUserId(userId);
    return compatibility?.overallScore;
  }

  /// Get compatibility report by user ID
  Future<String?> getCompatibilityReportByUserId(String userId) async {
    final compatibility = await getCompatibilityByUserId(userId);
    return compatibility?.report;
  }

  /// Get compatibility aspects by user ID
  Future<List<CompatibilityAspect>?> getCompatibilityAspectsByUserId(
      String userId) async {
    final compatibility = await getCompatibilityByUserId(userId);
    return compatibility?.aspects;
  }

  /// Get compatibility by profile
  Future<Compatibility?> getCompatibilityByProfile(Profile profile) async {
    return await getCompatibilityByUserId(profile.userId);
  }

  /// Get compatibility score by profile
  Future<int?> getCompatibilityScoreByProfile(Profile profile) async {
    return await getCompatibilityScoreByUserId(profile.userId);
  }

  /// Get compatibility report by profile
  Future<String?> getCompatibilityReportByProfile(Profile profile) async {
    return await getCompatibilityReportByUserId(profile.userId);
  }

  /// Get compatibility aspects by profile
  Future<List<CompatibilityAspect>?> getCompatibilityAspectsByProfile(
      Profile profile) async {
    return await getCompatibilityAspectsByUserId(profile.userId);
  }

  /// Get most compatible profiles
  Future<List<Profile>> getMostCompatibleProfiles({
    required int minAge,
    required int maxAge,
    required Gender gender,
    required LookingFor lookingFor,
    int limit = 10,
  }) async {
    if (_authProvider.currentUser == null || !_chartProvider.hasChart) {
      return [];
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      // Get profiles that match the criteria
      final profiles = await ServiceRegistry.profileService.searchProfiles(
        gender: gender,
        lookingFor: lookingFor,
        minAge: minAge,
        maxAge: maxAge,
        latitude: 0, // Not used for this search
        longitude: 0, // Not used for this search
        maxDistance: 0, // Not used for this search
        limit: 50, // Get more profiles than needed to filter by compatibility
      );

      // Calculate compatibility for each profile
      final compatibilityScores = <String, int>{};

      for (final profile in profiles) {
        final compatibility = await getCompatibilityByUserId(profile.userId);
        if (compatibility != null) {
          compatibilityScores[profile.userId] = compatibility.overallScore;
        }
      }

      // Sort profiles by compatibility score
      profiles.sort((a, b) {
        final scoreA = compatibilityScores[a.userId] ?? 0;
        final scoreB = compatibilityScores[b.userId] ?? 0;
        return scoreB.compareTo(scoreA);
      });

      // Return top profiles
      _errorMessage = null;
      return profiles.take(limit).toList();
    } catch (e) {
      _errorMessage = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get compatibility by charts
  Future<Compatibility> getCompatibilityByCharts(
      Chart chart1, Chart chart2) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Use the user IDs from the charts to calculate compatibility
      final compatibility =
          await ServiceRegistry.compatibilityService.calculateCompatibility(
        chart1.userId,
        chart2.userId,
      );

      _errorMessage = null;
      return compatibility;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update auth provider
  void updateAuthProvider({required AuthProvider authProvider}) {
    if (_authProvider.currentUser?.id != authProvider.currentUser?.id) {
      clearCache();
    }
  }

  /// Update profile provider
  void updateProfileProvider({required ProfileProvider profileProvider}) {
    if (_profileProvider.currentProfile?.userId !=
        profileProvider.currentProfile?.userId) {
      clearCache();
    }
  }

  /// Update chart provider
  void updateChartProvider({required ChartProvider chartProvider}) {
    if (_chartProvider.currentUserChart?.userId !=
        chartProvider.currentUserChart?.userId) {
      clearCache();
    }
  }

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Clear cache
  void clearCache() {
    _compatibilities.clear();
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
