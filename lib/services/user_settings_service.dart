import '../config/app_config.dart';
import '../models/user_settings.dart';
import 'supabase_service.dart';

/// User settings service
class UserSettingsService {
  /// Table name
  static const String _tableName = AppConfig.supabaseUserSettingsTable;

  /// Get user settings by user ID
  Future<UserSettings?> getUserSettingsByUserId(String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserSettings.fromJson(response);
  }

  /// Create user settings
  Future<UserSettings> createUserSettings(UserSettings settings) async {
    final response = await SupabaseService.from(_tableName)
        .insert(settings.toJson())
        .select()
        .single();

    return UserSettings.fromJson(response);
  }

  /// Update user settings
  Future<UserSettings> updateUserSettings(UserSettings settings) async {
    final response = await SupabaseService.from(_tableName)
        .update(settings.toJson())
        .eq('user_id', settings.userId)
        .select()
        .single();

    return UserSettings.fromJson(response);
  }

  /// Delete user settings
  Future<void> deleteUserSettings(String userId) async {
    await SupabaseService.from(_tableName).delete().eq('user_id', userId);
  }

  /// Create or update user settings
  Future<UserSettings> createOrUpdateUserSettings(UserSettings settings) async {
    final existingSettings = await getUserSettingsByUserId(settings.userId);

    if (existingSettings != null) {
      return await updateUserSettings(settings);
    } else {
      return await createUserSettings(settings);
    }
  }

  /// Update theme mode
  Future<UserSettings> updateThemeMode(
      String userId, ThemeMode themeMode) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          themeMode: themeMode,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          themeMode: themeMode,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update language
  Future<UserSettings> updateLanguage(String userId, Language language) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          language: language,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          language: language,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update distance unit
  Future<UserSettings> updateDistanceUnit(
      String userId, DistanceUnit distanceUnit) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          distanceUnit: distanceUnit,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          distanceUnit: distanceUnit,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update temperature unit
  Future<UserSettings> updateTemperatureUnit(
      String userId, TemperatureUnit temperatureUnit) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          temperatureUnit: temperatureUnit,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          temperatureUnit: temperatureUnit,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update time format
  Future<UserSettings> updateTimeFormat(
      String userId, TimeFormat timeFormat) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          timeFormat: timeFormat,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          timeFormat: timeFormat,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update date format
  Future<UserSettings> updateDateFormat(
      String userId, DateFormat dateFormat) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          dateFormat: dateFormat,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          dateFormat: dateFormat,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update push notifications enabled
  Future<UserSettings> updatePushNotificationsEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          pushNotificationsEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          pushNotificationsEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update email notifications enabled
  Future<UserSettings> updateEmailNotificationsEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          emailNotificationsEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          emailNotificationsEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update in-app notifications enabled
  Future<UserSettings> updateInAppNotificationsEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          inAppNotificationsEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          inAppNotificationsEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update SMS notifications enabled
  Future<UserSettings> updateSmsNotificationsEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          smsNotificationsEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          smsNotificationsEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update location services enabled
  Future<UserSettings> updateLocationServicesEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          locationServicesEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          locationServicesEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update location sharing enabled
  Future<UserSettings> updateLocationSharingEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          locationSharingEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          locationSharingEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update activity sharing enabled
  Future<UserSettings> updateActivitySharingEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          activitySharingEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          activitySharingEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update profile visibility enabled
  Future<UserSettings> updateProfileVisibilityEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          profileVisibilityEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          profileVisibilityEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update incognito mode enabled
  Future<UserSettings> updateIncognitoModeEnabled(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          incognitoModeEnabled: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          incognitoModeEnabled: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show online status
  Future<UserSettings> updateShowOnlineStatus(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showOnlineStatus: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showOnlineStatus: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show last active
  Future<UserSettings> updateShowLastActive(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showLastActive: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showLastActive: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show read receipts
  Future<UserSettings> updateShowReadReceipts(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showReadReceipts: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showReadReceipts: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show typing indicators
  Future<UserSettings> updateShowTypingIndicators(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showTypingIndicators: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showTypingIndicators: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show distance
  Future<UserSettings> updateShowDistance(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showDistance: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showDistance: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show age
  Future<UserSettings> updateShowAge(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showAge: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showAge: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show zodiac sign
  Future<UserSettings> updateShowZodiacSign(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showZodiacSign: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showZodiacSign: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update show compatibility score
  Future<UserSettings> updateShowCompatibilityScore(
      String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          showCompatibilityScore: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          showCompatibilityScore: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update auto play videos
  Future<UserSettings> updateAutoPlayVideos(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);

    if (settings == null) {
      return await createUserSettings(
        UserSettings.defaultSettings(userId).copyWith(
          autoPlayVideos: enabled,
        ),
      );
    } else {
      return await updateUserSettings(
        settings.copyWith(
          autoPlayVideos: enabled,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Get default user settings
  UserSettings getDefaultUserSettings(String userId) {
    return UserSettings.defaultSettings(userId);
  }
}
