/// Application constants
class AppConstants {
  /// Private constructor to prevent instantiation
  const AppConstants._();

  // General
  /// Default animation duration
  static const int defaultAnimationDuration = 300;

  /// Default page size
  static const int defaultPageSize = 20;

  /// Default debounce duration
  static const int defaultDebounceDuration = 500;

  /// Default throttle duration
  static const int defaultThrottleDuration = 500;

  /// Default cache duration
  static const int defaultCacheDuration = 3600; // 1 hour

  /// Default timeout duration
  static const int defaultTimeoutDuration = 30000; // 30 seconds

  /// Default retry count
  static const int defaultRetryCount = 3;

  /// Default retry delay
  static const int defaultRetryDelay = 1000; // 1 second

  /// Default max file size
  static const int defaultMaxFileSize = 10 * 1024 * 1024; // 10 MB

  /// Default max image size
  static const int defaultMaxImageSize = 5 * 1024 * 1024; // 5 MB

  /// Default max video size
  static const int defaultMaxVideoSize = 50 * 1024 * 1024; // 50 MB

  /// Default max audio size
  static const int defaultMaxAudioSize = 10 * 1024 * 1024; // 10 MB

  /// Default max document size
  static const int defaultMaxDocumentSize = 10 * 1024 * 1024; // 10 MB

  /// Default max image width
  static const int defaultMaxImageWidth = 1920;

  /// Default max image height
  static const int defaultMaxImageHeight = 1080;

  /// Default image quality
  static const int defaultImageQuality = 80;

  /// Default image format
  static const String defaultImageFormat = 'jpeg';

  /// Default video format
  static const String defaultVideoFormat = 'mp4';

  /// Default audio format
  static const String defaultAudioFormat = 'mp3';

  /// Default document format
  static const String defaultDocumentFormat = 'pdf';

  /// Default date format
  static const String defaultDateFormat = 'MMM d, yyyy';

  /// Default time format
  static const String defaultTimeFormat = 'h:mm a';

  /// Default date time format
  static const String defaultDateTimeFormat = 'MMM d, yyyy h:mm a';

  /// Default currency format
  static const String defaultCurrencyFormat = '\$#,##0.00';

  /// Default number format
  static const String defaultNumberFormat = '#,##0.00';

  /// Default percentage format
  static const String defaultPercentageFormat = '#,##0.00%';

  /// Default decimal places
  static const int defaultDecimalPlaces = 2;

  /// Default language
  static const String defaultLanguage = 'en';

  /// Default country
  static const String defaultCountry = 'US';

  /// Default timezone
  static const String defaultTimezone = 'UTC';

  /// Default currency
  static const String defaultCurrency = 'USD';

  /// Default currency symbol
  static const String defaultCurrencySymbol = '\$';

  /// Default distance unit
  static const String defaultDistanceUnit = 'km';

  /// Default weight unit
  static const String defaultWeightUnit = 'kg';

  /// Default height unit
  static const String defaultHeightUnit = 'cm';

  /// Default temperature unit
  static const String defaultTemperatureUnit = 'C';

  /// Default speed unit
  static const String defaultSpeedUnit = 'km/h';

  /// Default volume unit
  static const String defaultVolumeUnit = 'L';

  /// Default area unit
  static const String defaultAreaUnit = 'm²';

  /// Default pressure unit
  static const String defaultPressureUnit = 'hPa';

  /// Default energy unit
  static const String defaultEnergyUnit = 'kJ';

  /// Default power unit
  static const String defaultPowerUnit = 'W';

  /// Default time unit
  static const String defaultTimeUnit = 's';

  /// Default angle unit
  static const String defaultAngleUnit = '°';

  /// Default frequency unit
  static const String defaultFrequencyUnit = 'Hz';

  /// Default data unit
  static const String defaultDataUnit = 'B';

  /// Default data rate unit
  static const String defaultDataRateUnit = 'B/s';

  /// Default pixel density unit
  static const String defaultPixelDensityUnit = 'ppi';

  /// Default resolution unit
  static const String defaultResolutionUnit = 'px';

  /// Default font size unit
  static const String defaultFontSizeUnit = 'sp';

  /// Default dimension unit
  static const String defaultDimensionUnit = 'dp';

  /// Default duration unit
  static const String defaultDurationUnit = 'ms';

  /// Default latitude
  static const double defaultLatitude = 0.0;

  /// Default longitude
  static const double defaultLongitude = 0.0;

  /// Default zoom level
  static const double defaultZoomLevel = 13.0;

  /// Default latitude min
  static const double defaultLatitudeMin = -90.0;

  /// Default latitude max
  static const double defaultLatitudeMax = 90.0;

  /// Default longitude min
  static const double defaultLongitudeMin = -180.0;

  /// Default longitude max
  static const double defaultLongitudeMax = 180.0;

  /// Default distance min
  static const double defaultDistanceMin = 0.0;

  /// Default distance max
  static const double defaultDistanceMax = 100.0;

  /// Default budget min
  static const double defaultBudgetMin = 0.0;

  /// Default budget max
  static const double defaultBudgetMax = 1000.0;

  /// Default score min
  static const int defaultScoreMin = 0;

  /// Default score max
  static const int defaultScoreMax = 100;

  /// Default orb min
  static const double defaultOrbMin = 0.0;

  /// Default orb max
  static const double defaultOrbMax = 10.0;

  /// Default degree min
  static const double defaultDegreeMin = 0.0;

  /// Default degree max
  static const double defaultDegreeMax = 360.0;

  /// Default house min
  static const int defaultHouseMin = 1;

  /// Default house max
  static const int defaultHouseMax = 12;

  /// Default day min
  static const int defaultDayMin = 1;

  /// Default day max
  static const int defaultDayMax = 31;

  /// Default age min
  static const int defaultAgeMin = 18;

  /// Default age max
  static const int defaultAgeMax = 100;

  // Text lengths
  /// Default first name length
  static const int defaultFirstNameLength = 50;

  /// Default last name length
  static const int defaultLastNameLength = 50;

  /// Default display name length
  static const int defaultDisplayNameLength = 50;

  /// Default username length
  static const int defaultUsernameLength = 30;

  /// Default email min length
  static const int defaultEmailMinLength = 5;

  /// Default email max length
  static const int defaultEmailMaxLength = 100;

  /// Default password min length
  static const int defaultPasswordMinLength = 8;

  /// Default password max length
  static const int defaultPasswordMaxLength = 100;

  /// Default phone min length
  static const int defaultPhoneMinLength = 10;

  /// Default phone max length
  static const int defaultPhoneMaxLength = 15;

  /// Default bio length
  static const int defaultBioLength = 500;

  /// Default location length
  static const int defaultLocationLength = 100;

  /// Default birth location length
  static const int defaultBirthLocationLength = 100;

  /// Default message text length
  static const int defaultMessageTextLength = 1000;

  /// Default notification title length
  static const int defaultNotificationTitleLength = 100;

  /// Default notification body length
  static const int defaultNotificationBodyLength = 500;

  /// Default title length
  static const int defaultTitleLength = 100;

  /// Default description length
  static const int defaultDescriptionLength = 500;

  /// Default notes length
  static const int defaultNotesLength = 1000;

  /// Default activity name length
  static const int defaultActivityNameLength = 100;

  /// Default location name length
  static const int defaultLocationNameLength = 100;

  /// Default time length
  static const int defaultTimeLength = 10;

  /// Default language code length
  static const int defaultLanguageCodeLength = 10;

  // Regex patterns
  /// Email regex pattern
  static const String emailRegexPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  /// Password regex pattern (at least 8 characters, 1 uppercase, 1 lowercase, 1 number)
  static const String passwordRegexPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\W]{8,}$';

  /// Phone regex pattern
  static const String phoneRegexPattern = r'^\+?[0-9]{10,15}$';

  /// URL regex pattern
  static const String urlRegexPattern = r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

  /// Date regex pattern (YYYY-MM-DD)
  static const String dateRegexPattern = r'^\d{4}-\d{2}-\d{2}$';

  /// Time regex pattern (HH:MM)
  static const String timeRegexPattern = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$';

  /// Latitude regex pattern
  static const String latitudeRegexPattern = r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$';

  /// Longitude regex pattern
  static const String longitudeRegexPattern = r'^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$';

  /// Username regex pattern (alphanumeric, underscore, hyphen, 3-30 characters)
  static const String usernameRegexPattern = r'^[a-zA-Z0-9_-]{3,30}$';

  /// Display name regex pattern (letters, numbers, spaces, 3-50 characters)
  static const String displayNameRegexPattern = r'^[a-zA-Z0-9 ]{3,50}$';

  /// Name regex pattern (letters, spaces, 1-50 characters)
  static const String nameRegexPattern = r'^[a-zA-Z ]{1,50}$';

  /// Zip code regex pattern (US)
  static const String zipCodeRegexPattern = r'^\d{5}(-\d{4})?$';

  /// Credit card number regex pattern
  static const String creditCardNumberRegexPattern = r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$';

  /// CVV regex pattern
  static const String cvvRegexPattern = r'^[0-9]{3,4}$';

  /// Expiry date regex pattern (MM/YY)
  static const String expiryDateRegexPattern = r'^(0[1-9]|1[0-2])\/([0-9]{2})$';

  /// Hex color regex pattern
  static const String hexColorRegexPattern = r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$';

  /// RGB color regex pattern
  static const String rgbColorRegexPattern = r'^rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$';

  /// RGBA color regex pattern
  static const String rgbaColorRegexPattern = r'^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d*(?:\.\d+)?)\s*\)$';

  /// HSL color regex pattern
  static const String hslColorRegexPattern = r'^hsl\(\s*(\d{1,3})\s*,\s*(\d{1,3})%\s*,\s*(\d{1,3})%\s*\)$';

  /// HSLA color regex pattern
  static const String hslaColorRegexPattern = r'^hsla\(\s*(\d{1,3})\s*,\s*(\d{1,3})%\s*,\s*(\d{1,3})%\s*,\s*(\d*(?:\.\d+)?)\s*\)$';

  /// IP address regex pattern
  static const String ipAddressRegexPattern = r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';

  /// MAC address regex pattern
  static const String macAddressRegexPattern = r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$';

  /// UUID regex pattern
  static const String uuidRegexPattern = r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$';

  /// ISBN regex pattern
  static const String isbnRegexPattern = r'^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$';

  /// Alpha regex pattern
  static const String alphaRegexPattern = r'^[a-zA-Z]+$';

  /// Alphanumeric regex pattern
  static const String alphanumericRegexPattern = r'^[a-zA-Z0-9]+$';

  /// Numeric regex pattern
  static const String numericRegexPattern = r'^[0-9]+$';

  /// Integer regex pattern
  static const String integerRegexPattern = r'^-?[0-9]+$';

  /// Decimal regex pattern
  static const String decimalRegexPattern = r'^-?[0-9]+(\.[0-9]+)?$';

  /// Positive integer regex pattern
  static const String positiveIntegerRegexPattern = r'^[1-9][0-9]*$';

  /// Positive decimal regex pattern
  static const String positiveDecimalRegexPattern = r'^[0-9]*\.?[0-9]+$';

  /// Negative integer regex pattern
  static const String negativeIntegerRegexPattern = r'^-[1-9][0-9]*$';

  /// Negative decimal regex pattern
  static const String negativeDecimalRegexPattern = r'^-[0-9]*\.?[0-9]+$';

  /// Non-negative integer regex pattern
  static const String nonNegativeIntegerRegexPattern = r'^[0-9]+$';

  /// Non-negative decimal regex pattern
  static const String nonNegativeDecimalRegexPattern = r'^[0-9]*\.?[0-9]+$';

  /// Non-positive integer regex pattern
  static const String nonPositiveIntegerRegexPattern = r'^(-[1-9][0-9]*|0)$';

  /// Non-positive decimal regex pattern
  static const String nonPositiveDecimalRegexPattern = r'^(-[0-9]*\.?[0-9]+|0(\.0+)?)$';

  // Zodiac signs
  /// Aries date range start
  static const int ariesDateRangeStart = 321; // March 21

  /// Aries date range end
  static const int ariesDateRangeEnd = 419; // April 19

  /// Taurus date range start
  static const int taurusDateRangeStart = 420; // April 20

  /// Taurus date range end
  static const int taurusDateRangeEnd = 520; // May 20

  /// Gemini date range start
  static const int geminiDateRangeStart = 521; // May 21

  /// Gemini date range end
  static const int geminiDateRangeEnd = 620; // June 20

  /// Cancer date range start
  static const int cancerDateRangeStart = 621; // June 21

  /// Cancer date range end
  static const int cancerDateRangeEnd = 722; // July 22

  /// Leo date range start
  static const int leoDateRangeStart = 723; // July 23

  /// Leo date range end
  static const int leoDateRangeEnd = 822; // August 22

  /// Virgo date range start
  static const int virgoDateRangeStart = 823; // August 23

  /// Virgo date range end
  static const int virgoDateRangeEnd = 922; // September 22

  /// Libra date range start
  static const int libraDateRangeStart = 923; // September 23

  /// Libra date range end
  static const int libraDateRangeEnd = 1022; // October 22

  /// Scorpio date range start
  static const int scorpioDateRangeStart = 1023; // October 23

  /// Scorpio date range end
  static const int scorpioDateRangeEnd = 1121; // November 21

  /// Sagittarius date range start
  static const int sagittariusDateRangeStart = 1122; // November 22

  /// Sagittarius date range end
  static const int sagittariusDateRangeEnd = 1221; // December 21

  /// Capricorn date range start
  static const int capricornDateRangeStart = 1222; // December 22

  /// Capricorn date range end
  static const int capricornDateRangeEnd = 119; // January 19

  /// Aquarius date range start
  static const int aquariusDateRangeStart = 120; // January 20

  /// Aquarius date range end
  static const int aquariusDateRangeEnd = 218; // February 18

  /// Pisces date range start
  static const int piscesDateRangeStart = 219; // February 19

  /// Pisces date range end
  static const int piscesDateRangeEnd = 320; // March 20
}
