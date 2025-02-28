import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_settings.g.dart';

/// Theme mode enum
enum ThemeMode {
  /// System theme mode
  system,

  /// Light theme mode
  light,

  /// Dark theme mode
  dark,
}

/// Language enum
enum Language {
  /// English
  english,

  /// Spanish
  spanish,

  /// French
  french,

  /// German
  german,

  /// Italian
  italian,

  /// Portuguese
  portuguese,

  /// Russian
  russian,

  /// Chinese
  chinese,

  /// Japanese
  japanese,

  /// Korean
  korean,
}

/// Distance unit enum
enum DistanceUnit {
  /// Kilometers
  kilometers,

  /// Miles
  miles,
}

/// Temperature unit enum
enum TemperatureUnit {
  /// Celsius
  celsius,

  /// Fahrenheit
  fahrenheit,
}

/// Time format enum
enum TimeFormat {
  /// 12-hour
  twelveHour,

  /// 24-hour
  twentyFourHour,
}

/// Date format enum
enum DateFormat {
  /// Month/Day/Year
  monthDayYear,

  /// Day/Month/Year
  dayMonthYear,

  /// Year/Month/Day
  yearMonthDay,
}

/// User settings model
@JsonSerializable()
class UserSettings extends Equatable {
  /// User ID
  final String userId;

  /// Theme mode
  final ThemeMode themeMode;

  /// Language
  final Language language;

  /// Distance unit
  final DistanceUnit distanceUnit;

  /// Temperature unit
  final TemperatureUnit temperatureUnit;

  /// Time format
  final TimeFormat timeFormat;

  /// Date format
  final DateFormat dateFormat;

  /// Push notifications enabled
  final bool pushNotificationsEnabled;

  /// Email notifications enabled
  final bool emailNotificationsEnabled;

  /// In-app notifications enabled
  final bool inAppNotificationsEnabled;

  /// SMS notifications enabled
  final bool smsNotificationsEnabled;

  /// Location services enabled
  final bool locationServicesEnabled;

  /// Location sharing enabled
  final bool locationSharingEnabled;

  /// Activity sharing enabled
  final bool activitySharingEnabled;

  /// Profile visibility enabled
  final bool profileVisibilityEnabled;

  /// Incognito mode enabled
  final bool incognitoModeEnabled;

  /// Show online status
  final bool showOnlineStatus;

  /// Show last active
  final bool showLastActive;

  /// Show read receipts
  final bool showReadReceipts;

  /// Show typing indicators
  final bool showTypingIndicators;

  /// Show distance
  final bool showDistance;

  /// Show age
  final bool showAge;

  /// Show zodiac sign
  final bool showZodiacSign;

  /// Show compatibility score
  final bool showCompatibilityScore;

  /// Auto play videos
  final bool autoPlayVideos;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [UserSettings] instance
  const UserSettings({
    required this.userId,
    required this.themeMode,
    required this.language,
    required this.distanceUnit,
    required this.temperatureUnit,
    required this.timeFormat,
    required this.dateFormat,
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.inAppNotificationsEnabled,
    required this.smsNotificationsEnabled,
    required this.locationServicesEnabled,
    required this.locationSharingEnabled,
    required this.activitySharingEnabled,
    required this.profileVisibilityEnabled,
    required this.incognitoModeEnabled,
    required this.showOnlineStatus,
    required this.showLastActive,
    required this.showReadReceipts,
    required this.showTypingIndicators,
    required this.showDistance,
    required this.showAge,
    required this.showZodiacSign,
    required this.showCompatibilityScore,
    required this.autoPlayVideos,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [UserSettings] instance from JSON
  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  /// Converts this [UserSettings] instance to JSON
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  /// Creates a copy of this [UserSettings] instance with the given fields replaced
  UserSettings copyWith({
    String? userId,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    TemperatureUnit? temperatureUnit,
    TimeFormat? timeFormat,
    DateFormat? dateFormat,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? inAppNotificationsEnabled,
    bool? smsNotificationsEnabled,
    bool? locationServicesEnabled,
    bool? locationSharingEnabled,
    bool? activitySharingEnabled,
    bool? profileVisibilityEnabled,
    bool? incognitoModeEnabled,
    bool? showOnlineStatus,
    bool? showLastActive,
    bool? showReadReceipts,
    bool? showTypingIndicators,
    bool? showDistance,
    bool? showAge,
    bool? showZodiacSign,
    bool? showCompatibilityScore,
    bool? autoPlayVideos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      timeFormat: timeFormat ?? this.timeFormat,
      dateFormat: dateFormat ?? this.dateFormat,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      inAppNotificationsEnabled:
          inAppNotificationsEnabled ?? this.inAppNotificationsEnabled,
      smsNotificationsEnabled:
          smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      locationServicesEnabled:
          locationServicesEnabled ?? this.locationServicesEnabled,
      locationSharingEnabled:
          locationSharingEnabled ?? this.locationSharingEnabled,
      activitySharingEnabled:
          activitySharingEnabled ?? this.activitySharingEnabled,
      profileVisibilityEnabled:
          profileVisibilityEnabled ?? this.profileVisibilityEnabled,
      incognitoModeEnabled: incognitoModeEnabled ?? this.incognitoModeEnabled,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      showLastActive: showLastActive ?? this.showLastActive,
      showReadReceipts: showReadReceipts ?? this.showReadReceipts,
      showTypingIndicators: showTypingIndicators ?? this.showTypingIndicators,
      showDistance: showDistance ?? this.showDistance,
      showAge: showAge ?? this.showAge,
      showZodiacSign: showZodiacSign ?? this.showZodiacSign,
      showCompatibilityScore:
          showCompatibilityScore ?? this.showCompatibilityScore,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Default user settings
  static UserSettings defaultSettings(String userId) {
    final now = DateTime.now();
    return UserSettings(
      userId: userId,
      themeMode: ThemeMode.system,
      language: Language.english,
      distanceUnit: DistanceUnit.kilometers,
      temperatureUnit: TemperatureUnit.celsius,
      timeFormat: TimeFormat.twelveHour,
      dateFormat: DateFormat.monthDayYear,
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: true,
      inAppNotificationsEnabled: true,
      smsNotificationsEnabled: false,
      locationServicesEnabled: true,
      locationSharingEnabled: true,
      activitySharingEnabled: true,
      profileVisibilityEnabled: true,
      incognitoModeEnabled: false,
      showOnlineStatus: true,
      showLastActive: true,
      showReadReceipts: true,
      showTypingIndicators: true,
      showDistance: true,
      showAge: true,
      showZodiacSign: true,
      showCompatibilityScore: true,
      autoPlayVideos: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty user settings
  static final empty = UserSettings(
    userId: '',
    themeMode: ThemeMode.system,
    language: Language.english,
    distanceUnit: DistanceUnit.kilometers,
    temperatureUnit: TemperatureUnit.celsius,
    timeFormat: TimeFormat.twelveHour,
    dateFormat: DateFormat.monthDayYear,
    pushNotificationsEnabled: false,
    emailNotificationsEnabled: false,
    inAppNotificationsEnabled: false,
    smsNotificationsEnabled: false,
    locationServicesEnabled: false,
    locationSharingEnabled: false,
    activitySharingEnabled: false,
    profileVisibilityEnabled: false,
    incognitoModeEnabled: false,
    showOnlineStatus: false,
    showLastActive: false,
    showReadReceipts: false,
    showTypingIndicators: false,
    showDistance: false,
    showAge: false,
    showZodiacSign: false,
    showCompatibilityScore: false,
    autoPlayVideos: false,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == UserSettings.empty;

  /// Is not empty
  bool get isNotEmpty => this != UserSettings.empty;

  /// Get theme mode name
  static String getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  /// Get language name
  static String getLanguageName(Language language) {
    switch (language) {
      case Language.english:
        return 'English';
      case Language.spanish:
        return 'Spanish';
      case Language.french:
        return 'French';
      case Language.german:
        return 'German';
      case Language.italian:
        return 'Italian';
      case Language.portuguese:
        return 'Portuguese';
      case Language.russian:
        return 'Russian';
      case Language.chinese:
        return 'Chinese';
      case Language.japanese:
        return 'Japanese';
      case Language.korean:
        return 'Korean';
    }
  }

  /// Get language code
  static String getLanguageCode(Language language) {
    switch (language) {
      case Language.english:
        return 'en';
      case Language.spanish:
        return 'es';
      case Language.french:
        return 'fr';
      case Language.german:
        return 'de';
      case Language.italian:
        return 'it';
      case Language.portuguese:
        return 'pt';
      case Language.russian:
        return 'ru';
      case Language.chinese:
        return 'zh';
      case Language.japanese:
        return 'ja';
      case Language.korean:
        return 'ko';
    }
  }

  /// Get distance unit name
  static String getDistanceUnitName(DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.kilometers:
        return 'Kilometers';
      case DistanceUnit.miles:
        return 'Miles';
    }
  }

  /// Get distance unit abbreviation
  static String getDistanceUnitAbbreviation(DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.kilometers:
        return 'km';
      case DistanceUnit.miles:
        return 'mi';
    }
  }

  /// Get temperature unit name
  static String getTemperatureUnitName(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.celsius:
        return 'Celsius';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit';
    }
  }

  /// Get temperature unit symbol
  static String getTemperatureUnitSymbol(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
    }
  }

  /// Get time format name
  static String getTimeFormatName(TimeFormat format) {
    switch (format) {
      case TimeFormat.twelveHour:
        return '12-hour';
      case TimeFormat.twentyFourHour:
        return '24-hour';
    }
  }

  /// Get date format name
  static String getDateFormatName(DateFormat format) {
    switch (format) {
      case DateFormat.monthDayYear:
        return 'MM/DD/YYYY';
      case DateFormat.dayMonthYear:
        return 'DD/MM/YYYY';
      case DateFormat.yearMonthDay:
        return 'YYYY/MM/DD';
    }
  }

  @override
  List<Object?> get props => [
        userId,
        themeMode,
        language,
        distanceUnit,
        temperatureUnit,
        timeFormat,
        dateFormat,
        pushNotificationsEnabled,
        emailNotificationsEnabled,
        inAppNotificationsEnabled,
        smsNotificationsEnabled,
        locationServicesEnabled,
        locationSharingEnabled,
        activitySharingEnabled,
        profileVisibilityEnabled,
        incognitoModeEnabled,
        showOnlineStatus,
        showLastActive,
        showReadReceipts,
        showTypingIndicators,
        showDistance,
        showAge,
        showZodiacSign,
        showCompatibilityScore,
        autoPlayVideos,
        createdAt,
        updatedAt,
      ];
}
