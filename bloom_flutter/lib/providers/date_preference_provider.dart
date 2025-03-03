import 'package:flutter/foundation.dart';

import '../models/astrology.dart';
import '../models/date_preference.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../services/service_registry.dart';

/// Date preference provider
class DatePreferenceProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Profile provider
  final ProfileProvider _profileProvider;

  /// Date preference
  DatePreference? _datePreference;

  /// Date suggestions
  List<DateSuggestion> _dateSuggestions = [];

  /// Recommended date suggestions
  List<DateSuggestion> _recommendedDateSuggestions = [];

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Creates a new [DatePreferenceProvider] instance
  DatePreferenceProvider({
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
      await _loadDatePreference();
      await _loadDateSuggestions();
      await _loadRecommendedDateSuggestions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load date preference
  Future<void> _loadDatePreference() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _datePreference = await ServiceRegistry.datePreferenceService
        .getDatePreferenceByUserId(userId);
  }

  /// Load date suggestions
  Future<void> _loadDateSuggestions() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _dateSuggestions = await ServiceRegistry.datePreferenceService
        .getDateSuggestionsByUserId(userId);
  }

  /// Load recommended date suggestions
  Future<void> _loadRecommendedDateSuggestions() async {
    if (_authProvider.currentUser == null ||
        _profileProvider.currentProfile == null) {
      return;
    }

    // For now, we'll just get suggestions by type
    // In a real app, we would use the compatibility service to get compatible matches
    // and then get their zodiac signs and elements
    _recommendedDateSuggestions =
        await ServiceRegistry.datePreferenceService.getDateSuggestionsByType(
      DateType.dining,
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

  /// Get date preference
  DatePreference? get datePreference => _datePreference;

  /// Get date suggestions
  List<DateSuggestion> get dateSuggestions => _dateSuggestions;

  /// Get recommended date suggestions
  List<DateSuggestion> get recommendedDateSuggestions =>
      _recommendedDateSuggestions;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Has date preference
  bool get hasDatePreference => _datePreference != null;

  /// Create date preference
  Future<void> createDatePreference(DatePreference preference) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _datePreference = await ServiceRegistry.datePreferenceService
          .createDatePreference(preference);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update date preference
  Future<void> updateDatePreference(DatePreference preference) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _datePreference = await ServiceRegistry.datePreferenceService
          .updateDatePreference(preference);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create or update date preference
  Future<void> createOrUpdateDatePreference(DatePreference preference) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _datePreference = await ServiceRegistry.datePreferenceService
          .createOrUpdateDatePreference(preference);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete date preference
  Future<void> deleteDatePreference() async {
    if (_datePreference == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.datePreferenceService
          .deleteDatePreference(_datePreference!.userId);
      _datePreference = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create date suggestion
  Future<void> createDateSuggestion(DateSuggestion suggestion) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newSuggestion = await ServiceRegistry.datePreferenceService
          .createDateSuggestion(suggestion);
      _dateSuggestions.add(newSuggestion);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update date suggestion
  Future<void> updateDateSuggestion(DateSuggestion suggestion) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSuggestion = await ServiceRegistry.datePreferenceService
          .updateDateSuggestion(suggestion);

      // Update in date suggestions list
      final index =
          _dateSuggestions.indexWhere((s) => s.id == updatedSuggestion.id);
      if (index != -1) {
        _dateSuggestions[index] = updatedSuggestion;
      }

      // Update in recommended date suggestions list
      final recIndex = _recommendedDateSuggestions
          .indexWhere((s) => s.id == updatedSuggestion.id);
      if (recIndex != -1) {
        _recommendedDateSuggestions[recIndex] = updatedSuggestion;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete date suggestion
  Future<void> deleteDateSuggestion(String suggestionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.datePreferenceService
          .deleteDateSuggestion(suggestionId);

      // Remove from date suggestions list
      _dateSuggestions.removeWhere((s) => s.id == suggestionId);

      // Remove from recommended date suggestions list
      _recommendedDateSuggestions.removeWhere((s) => s.id == suggestionId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create date suggestion for match
  Future<void> createDateSuggestionForMatch({
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
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      final suggestion = await ServiceRegistry.datePreferenceService
          .createDateSuggestionForMatch(
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
        scheduledDate: scheduledDate,
      );

      _dateSuggestions.add(suggestion);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Accept date suggestion
  Future<void> acceptDateSuggestion(String suggestionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSuggestion = await ServiceRegistry.datePreferenceService
          .acceptDateSuggestion(suggestionId);

      // Update in date suggestions list
      final index =
          _dateSuggestions.indexWhere((s) => s.id == updatedSuggestion.id);
      if (index != -1) {
        _dateSuggestions[index] = updatedSuggestion;
      }

      // Update in recommended date suggestions list
      final recIndex = _recommendedDateSuggestions
          .indexWhere((s) => s.id == updatedSuggestion.id);
      if (recIndex != -1) {
        _recommendedDateSuggestions[recIndex] = updatedSuggestion;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reject date suggestion
  Future<void> rejectDateSuggestion(String suggestionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSuggestion = await ServiceRegistry.datePreferenceService
          .rejectDateSuggestion(suggestionId);

      // Update in date suggestions list
      final index =
          _dateSuggestions.indexWhere((s) => s.id == updatedSuggestion.id);
      if (index != -1) {
        _dateSuggestions[index] = updatedSuggestion;
      }

      // Update in recommended date suggestions list
      final recIndex = _recommendedDateSuggestions
          .indexWhere((s) => s.id == updatedSuggestion.id);
      if (recIndex != -1) {
        _recommendedDateSuggestions[recIndex] = updatedSuggestion;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Schedule date suggestion
  Future<void> scheduleDateSuggestion(
      String suggestionId, DateTime scheduledDate) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSuggestion =
          await ServiceRegistry.datePreferenceService.scheduleDateSuggestion(
        suggestionId,
        scheduledDate,
      );

      // Update in date suggestions list
      final index =
          _dateSuggestions.indexWhere((s) => s.id == updatedSuggestion.id);
      if (index != -1) {
        _dateSuggestions[index] = updatedSuggestion;
      }

      // Update in recommended date suggestions list
      final recIndex = _recommendedDateSuggestions
          .indexWhere((s) => s.id == updatedSuggestion.id);
      if (recIndex != -1) {
        _recommendedDateSuggestions[recIndex] = updatedSuggestion;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Complete date suggestion
  Future<void> completeDateSuggestion(String suggestionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSuggestion = await ServiceRegistry.datePreferenceService
          .completeDateSuggestion(suggestionId);

      // Update in date suggestions list
      final index =
          _dateSuggestions.indexWhere((s) => s.id == updatedSuggestion.id);
      if (index != -1) {
        _dateSuggestions[index] = updatedSuggestion;
      }

      // Update in recommended date suggestions list
      final recIndex = _recommendedDateSuggestions
          .indexWhere((s) => s.id == updatedSuggestion.id);
      if (recIndex != -1) {
        _recommendedDateSuggestions[recIndex] = updatedSuggestion;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cancel date suggestion
  Future<void> cancelDateSuggestion(String suggestionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSuggestion = await ServiceRegistry.datePreferenceService
          .cancelDateSuggestion(suggestionId);

      // Update in date suggestions list
      final index =
          _dateSuggestions.indexWhere((s) => s.id == updatedSuggestion.id);
      if (index != -1) {
        _dateSuggestions[index] = updatedSuggestion;
      }

      // Update in recommended date suggestions list
      final recIndex = _recommendedDateSuggestions
          .indexWhere((s) => s.id == updatedSuggestion.id);
      if (recIndex != -1) {
        _recommendedDateSuggestions[recIndex] = updatedSuggestion;
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh date preference
  Future<void> refreshDatePreference() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadDatePreference();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh date suggestions
  Future<void> refreshDateSuggestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadDateSuggestions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh recommended date suggestions
  Future<void> refreshRecommendedDateSuggestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadRecommendedDateSuggestions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
