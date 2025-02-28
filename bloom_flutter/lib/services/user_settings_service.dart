import 'package:supabase_flutter/supabase_flutter.dart';

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
  Future<UserSettings> updateThemeMode(String userId, ThemeMode themeMode) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: themeMode,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateLanguage(String userId, String language) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: language,
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateDistanceUnit(String userId, DistanceUnit distanceUnit) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: distanceUnit,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateTemperatureUnit(String userId, TemperatureUnit temperatureUnit) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: temperatureUnit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateTimeFormat(String userId, TimeFormat timeFormat) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: timeFormat,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateDateFormat(String userId, DateFormat dateFormat) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: dateFormat,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updatePushNotificationsEnabled(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: enabled,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateEmailNotificationsEnabled(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: enabled,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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

  /// Update SMS notifications enabled
  Future<UserSettings> updateSmsNotificationsEnabled(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: enabled,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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

  /// Update location sharing enabled
  Future<UserSettings> updateLocationSharingEnabled(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: enabled,
          activitySharingEnabled: true,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateActivitySharingEnabled(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: enabled,
          profileVisibilityEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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
  Future<UserSettings> updateProfileVisibilityEnabled(String userId, bool enabled) async {
    final settings = await getUserSettingsByUserId(userId);
    
    if (settings == null) {
      return await createUserSettings(
        UserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
          language: 'en',
          distanceUnit: DistanceUnit.miles,
          temperatureUnit: TemperatureUnit.fahrenheit,
          timeFormat: TimeFormat.twelveHour,
          dateFormat: DateFormat.monthDayYear,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          smsNotificationsEnabled: false,
          locationSharingEnabled: true,
          activitySharingEnabled: true,
          profileVisibilityEnabled: enabled,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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

  /// Get default user settings
  UserSettings getDefaultUserSettings(String userId) {
    return UserSettings(
      userId: userId,
      themeMode: ThemeMode.system,
      language: 'en',
      distanceUnit: DistanceUnit.miles,
      temperatureUnit: TemperatureUnit.fahrenheit,
      timeFormat: TimeFormat.twelveHour,
      dateFormat: DateFormat.monthDayYear,
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: true,
      smsNotificationsEnabled: false,
      locationSharingEnabled: true,
      activitySharingEnabled: true,
      profileVisibilityEnabled: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
