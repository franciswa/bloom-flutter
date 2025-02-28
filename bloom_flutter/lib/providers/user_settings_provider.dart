import 'package:flutter/foundation.dart';

import '../models/user_settings.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../services/service_registry.dart';

/// User settings provider
class UserSettingsProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Theme provider
  final ThemeProvider _themeProvider;

  /// User settings
  UserSettings? _userSettings;

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Creates a new [UserSettingsProvider] instance
  UserSettingsProvider({
    required AuthProvider authProvider,
    required ThemeProvider themeProvider,
  })  : _authProvider = authProvider,
        _themeProvider = themeProvider {
    _init();
  }

  /// Initialize
  Future<void> _init() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _loadUserSettings();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load user settings
  Future<void> _loadUserSettings() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _userSettings = await ServiceRegistry.userSettingsService.getUserSettingsByUserId(userId);

    // Create default settings if none exist
    if (_userSettings == null) {
      _userSettings = ServiceRegistry.userSettingsService.getDefaultUserSettings(userId);
      await ServiceRegistry.userSettingsService.createUserSettings(_userSettings!);
    }

    // Update theme provider
    _themeProvider.updateFromUserSettings(_userSettings!);
    _themeProvider.setUserId(userId);
  }

  /// Update auth provider
  void updateAuthProvider({required AuthProvider authProvider}) {
    if (_authProvider.currentUser?.id != authProvider.currentUser?.id) {
      _init();
    }
  }

  /// Get user settings
  UserSettings? get userSettings => _userSettings;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Has user settings
  bool get hasUserSettings => _userSettings != null;

  /// Create user settings
  Future<void> createUserSettings(UserSettings settings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.createUserSettings(settings);
      
      // Update theme provider
      _themeProvider.updateFromUserSettings(_userSettings!);
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user settings
  Future<void> updateUserSettings(UserSettings settings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateUserSettings(settings);
      
      // Update theme provider
      _themeProvider.updateFromUserSettings(_userSettings!);
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create or update user settings
  Future<void> createOrUpdateUserSettings(UserSettings settings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.createOrUpdateUserSettings(settings);
      
      // Update theme provider
      _themeProvider.updateFromUserSettings(_userSettings!);
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete user settings
  Future<void> deleteUserSettings() async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.userSettingsService.deleteUserSettings(_userSettings!.userId);
      _userSettings = null;
      
      // Update theme provider
      _themeProvider.setUserId(null);
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateThemeMode(
        _userSettings!.userId,
        themeMode,
      );
      
      // Update theme provider
      _themeProvider.updateFromUserSettings(_userSettings!);
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update language
  Future<void> updateLanguage(String language) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateLanguage(
        _userSettings!.userId,
        language,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update distance unit
  Future<void> updateDistanceUnit(DistanceUnit distanceUnit) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateDistanceUnit(
        _userSettings!.userId,
        distanceUnit,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update temperature unit
  Future<void> updateTemperatureUnit(TemperatureUnit temperatureUnit) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateTemperatureUnit(
        _userSettings!.userId,
        temperatureUnit,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update time format
  Future<void> updateTimeFormat(TimeFormat timeFormat) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateTimeFormat(
        _userSettings!.userId,
        timeFormat,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update date format
  Future<void> updateDateFormat(DateFormat dateFormat) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateDateFormat(
        _userSettings!.userId,
        dateFormat,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update push notifications enabled
  Future<void> updatePushNotificationsEnabled(bool enabled) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updatePushNotificationsEnabled(
        _userSettings!.userId,
        enabled,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update email notifications enabled
  Future<void> updateEmailNotificationsEnabled(bool enabled) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateEmailNotificationsEnabled(
        _userSettings!.userId,
        enabled,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update SMS notifications enabled
  Future<void> updateSmsNotificationsEnabled(bool enabled) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateSmsNotificationsEnabled(
        _userSettings!.userId,
        enabled,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update location sharing enabled
  Future<void> updateLocationSharingEnabled(bool enabled) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateLocationSharingEnabled(
        _userSettings!.userId,
        enabled,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update activity sharing enabled
  Future<void> updateActivitySharingEnabled(bool enabled) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateActivitySharingEnabled(
        _userSettings!.userId,
        enabled,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile visibility enabled
  Future<void> updateProfileVisibilityEnabled(bool enabled) async {
    if (_userSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userSettings = await ServiceRegistry.userSettingsService.updateProfileVisibilityEnabled(
        _userSettings!.userId,
        enabled,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user settings
  Future<void> refreshUserSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadUserSettings();
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
