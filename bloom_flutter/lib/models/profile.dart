import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'astrology.dart';

part 'profile.g.dart';

/// Gender enum
enum Gender {
  /// Male
  male,

  /// Female
  female,

  /// Non-binary
  nonBinary,

  /// Other
  other,

  /// Prefer not to say
  preferNotToSay,
}

/// Looking for enum
enum LookingFor {
  /// Men
  men,

  /// Women
  women,

  /// Everyone
  everyone,
}

/// Profile model
@JsonSerializable()
class Profile extends Equatable {
  /// User ID
  final String userId;

  /// Display name
  final String displayName;

  /// First name
  final String firstName;

  /// Last name
  final String? lastName;

  /// Birth date
  final DateTime birthDate;

  /// Birth time
  final String? birthTime;

  /// Birth city
  final String birthCity;

  /// Birth country
  final String birthCountry;

  /// Birth location
  final String birthLocation;

  /// Birth latitude
  final double? birthLatitude;

  /// Birth longitude
  final double? birthLongitude;

  /// Current location
  final String? currentLocation;

  /// Current latitude
  final double? currentLatitude;

  /// Current longitude
  final double? currentLongitude;

  /// Bio
  final String? bio;

  /// Gender
  final Gender gender;

  /// Zodiac sign
  final ZodiacSign zodiacSign;

  /// Looking for
  final LookingFor lookingFor;

  /// Min age preference
  final int minAgePreference;

  /// Max age preference
  final int maxAgePreference;

  /// Max distance preference
  final double maxDistancePreference;

  /// Profile photo URL
  final String? profilePhotoUrl;

  /// Profile photo URLs
  final List<String> photoUrls;

  /// Is profile complete
  final bool isProfileComplete;

  /// Is profile visible
  final bool isProfileVisible;

  /// Is online
  final bool isOnline;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [Profile] instance
  const Profile({
    required this.userId,
    required this.displayName,
    required this.firstName,
    this.lastName,
    required this.birthDate,
    this.birthTime,
    required this.birthCity,
    required this.birthCountry,
    required this.birthLocation,
    this.birthLatitude,
    this.birthLongitude,
    this.currentLocation,
    this.currentLatitude,
    this.currentLongitude,
    this.bio,
    required this.gender,
    required this.zodiacSign,
    required this.lookingFor,
    required this.minAgePreference,
    required this.maxAgePreference,
    required this.maxDistancePreference,
    this.profilePhotoUrl,
    required this.photoUrls,
    required this.isProfileComplete,
    required this.isProfileVisible,
    this.isOnline = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [Profile] instance from JSON
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  /// Converts this [Profile] instance to JSON
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  /// Creates a copy of this [Profile] instance with the given fields replaced
  Profile copyWith({
    String? userId,
    String? displayName,
    String? firstName,
    String? Function()? lastName,
    DateTime? birthDate,
    String? Function()? birthTime,
    String? birthCity,
    String? birthCountry,
    String? birthLocation,
    double? Function()? birthLatitude,
    double? Function()? birthLongitude,
    String? Function()? currentLocation,
    double? Function()? currentLatitude,
    double? Function()? currentLongitude,
    String? Function()? bio,
    Gender? gender,
    ZodiacSign? zodiacSign,
    LookingFor? lookingFor,
    int? minAgePreference,
    int? maxAgePreference,
    double? maxDistancePreference,
    String? Function()? profilePhotoUrl,
    List<String>? photoUrls,
    bool? isProfileComplete,
    bool? isProfileVisible,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName != null ? lastName() : this.lastName,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime != null ? birthTime() : this.birthTime,
      birthCity: birthCity ?? this.birthCity,
      birthCountry: birthCountry ?? this.birthCountry,
      birthLocation: birthLocation ?? this.birthLocation,
      birthLatitude:
          birthLatitude != null ? birthLatitude() : this.birthLatitude,
      birthLongitude:
          birthLongitude != null ? birthLongitude() : this.birthLongitude,
      currentLocation:
          currentLocation != null ? currentLocation() : this.currentLocation,
      currentLatitude:
          currentLatitude != null ? currentLatitude() : this.currentLatitude,
      currentLongitude:
          currentLongitude != null ? currentLongitude() : this.currentLongitude,
      bio: bio != null ? bio() : this.bio,
      gender: gender ?? this.gender,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      lookingFor: lookingFor ?? this.lookingFor,
      minAgePreference: minAgePreference ?? this.minAgePreference,
      maxAgePreference: maxAgePreference ?? this.maxAgePreference,
      maxDistancePreference:
          maxDistancePreference ?? this.maxDistancePreference,
      profilePhotoUrl:
          profilePhotoUrl != null ? profilePhotoUrl() : this.profilePhotoUrl,
      photoUrls: photoUrls ?? this.photoUrls,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isProfileVisible: isProfileVisible ?? this.isProfileVisible,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty profile
  static final empty = Profile(
    userId: '',
    displayName: '',
    firstName: '',
    lastName: null,
    birthDate: _emptyDateTime,
    birthTime: null,
    birthCity: '',
    birthCountry: '',
    birthLocation: '',
    birthLatitude: null,
    birthLongitude: null,
    currentLocation: null,
    currentLatitude: null,
    currentLongitude: null,
    bio: null,
    gender: Gender.preferNotToSay,
    zodiacSign: ZodiacSign.aries,
    lookingFor: LookingFor.everyone,
    minAgePreference: 18,
    maxAgePreference: 99,
    maxDistancePreference: 100.0,
    profilePhotoUrl: null,
    photoUrls: const [],
    isProfileComplete: false,
    isProfileVisible: false,
    isOnline: false,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == Profile.empty;

  /// Is not empty
  bool get isNotEmpty => this != Profile.empty;

  /// Get age
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Get full name
  String get fullName => lastName != null ? '$firstName $lastName' : firstName;

  /// Has photos
  bool get hasPhotos => photoUrls.isNotEmpty;

  /// Main photo URL
  String? get mainPhotoUrl => photoUrls.isNotEmpty ? photoUrls.first : null;

  @override
  List<Object?> get props => [
        userId,
        displayName,
        firstName,
        lastName,
        birthDate,
        birthTime,
        birthCity,
        birthCountry,
        birthLocation,
        birthLatitude,
        birthLongitude,
        currentLocation,
        currentLatitude,
        currentLongitude,
        bio,
        gender,
        zodiacSign,
        lookingFor,
        minAgePreference,
        maxAgePreference,
        maxDistancePreference,
        profilePhotoUrl,
        photoUrls,
        isProfileComplete,
        isProfileVisible,
        isOnline,
        createdAt,
        updatedAt,
      ];
}
