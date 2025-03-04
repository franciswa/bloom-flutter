import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart.g.dart';

/// Zodiac sign enum
enum ZodiacSign {
  /// Aries
  aries,

  /// Taurus
  taurus,

  /// Gemini
  gemini,

  /// Cancer
  cancer,

  /// Leo
  leo,

  /// Virgo
  virgo,

  /// Libra
  libra,

  /// Scorpio
  scorpio,

  /// Sagittarius
  sagittarius,

  /// Capricorn
  capricorn,

  /// Aquarius
  aquarius,

  /// Pisces
  pisces,
}

/// Element enum
enum Element {
  /// Fire
  fire,

  /// Earth
  earth,

  /// Air
  air,

  /// Water
  water,
}

/// Modality enum
enum Modality {
  /// Cardinal
  cardinal,

  /// Fixed
  fixed,

  /// Mutable
  mutable,
}

/// Planet enum
enum Planet {
  /// Sun
  sun,

  /// Moon
  moon,

  /// Mercury
  mercury,

  /// Venus
  venus,

  /// Mars
  mars,

  /// Jupiter
  jupiter,

  /// Saturn
  saturn,

  /// Uranus
  uranus,

  /// Neptune
  neptune,

  /// Pluto
  pluto,
}

/// House enum
enum House {
  /// First house
  first,

  /// Second house
  second,

  /// Third house
  third,

  /// Fourth house
  fourth,

  /// Fifth house
  fifth,

  /// Sixth house
  sixth,

  /// Seventh house
  seventh,

  /// Eighth house
  eighth,

  /// Ninth house
  ninth,

  /// Tenth house
  tenth,

  /// Eleventh house
  eleventh,

  /// Twelfth house
  twelfth,
}

/// Aspect enum
enum Aspect {
  /// Conjunction
  conjunction,

  /// Opposition
  opposition,

  /// Trine
  trine,

  /// Square
  square,

  /// Sextile
  sextile,
}

/// Planetary position model
@JsonSerializable()
class PlanetaryPosition extends Equatable {
  /// Planet
  final Planet planet;

  /// Zodiac sign
  final ZodiacSign sign;

  /// Degree
  final double degree;

  /// House
  final House house;

  /// Is retrograde
  final bool isRetrograde;

  /// Creates a new [PlanetaryPosition] instance
  const PlanetaryPosition({
    required this.planet,
    required this.sign,
    required this.degree,
    required this.house,
    required this.isRetrograde,
  });

  /// Creates a new [PlanetaryPosition] instance from JSON
  factory PlanetaryPosition.fromJson(Map<String, dynamic> json) => _$PlanetaryPositionFromJson(json);

  /// Converts this [PlanetaryPosition] instance to JSON
  Map<String, dynamic> toJson() => _$PlanetaryPositionToJson(this);

  @override
  List<Object?> get props => [planet, sign, degree, house, isRetrograde];
}

/// House cusp model
@JsonSerializable()
class HouseCusp extends Equatable {
  /// House
  final House house;

  /// Zodiac sign
  final ZodiacSign sign;

  /// Degree
  final double degree;

  /// Creates a new [HouseCusp] instance
  const HouseCusp({
    required this.house,
    required this.sign,
    required this.degree,
  });

  /// Creates a new [HouseCusp] instance from JSON
  factory HouseCusp.fromJson(Map<String, dynamic> json) => _$HouseCuspFromJson(json);

  /// Converts this [HouseCusp] instance to JSON
  Map<String, dynamic> toJson() => _$HouseCuspToJson(this);

  @override
  List<Object?> get props => [house, sign, degree];
}

/// Aspect model
@JsonSerializable()
class ChartAspect extends Equatable {
  /// Aspect
  final Aspect aspect;

  /// First planet
  final Planet firstPlanet;

  /// Second planet
  final Planet secondPlanet;

  /// Orb
  final double orb;

  /// Is applying
  final bool isApplying;

  /// Creates a new [ChartAspect] instance
  const ChartAspect({
    required this.aspect,
    required this.firstPlanet,
    required this.secondPlanet,
    required this.orb,
    required this.isApplying,
  });

  /// Creates a new [ChartAspect] instance from JSON
  factory ChartAspect.fromJson(Map<String, dynamic> json) => _$ChartAspectFromJson(json);

  /// Converts this [ChartAspect] instance to JSON
  Map<String, dynamic> toJson() => _$ChartAspectToJson(this);

  @override
  List<Object?> get props => [aspect, firstPlanet, secondPlanet, orb, isApplying];
}

/// Chart model
@JsonSerializable()
class Chart extends Equatable {
  /// User ID
  final String userId;

  /// Birth date
  final DateTime birthDate;

  /// Birth time
  final String? birthTime;

  /// Birth location
  final String birthLocation;

  /// Birth latitude
  final double? birthLatitude;

  /// Birth longitude
  final double? birthLongitude;

  /// Sun sign
  final ZodiacSign sunSign;

  /// Moon sign
  final ZodiacSign moonSign;

  /// Ascendant sign
  final ZodiacSign? ascendantSign;

  /// Mercury sign
  final ZodiacSign? mercurySign;

  /// Venus sign
  final ZodiacSign? venusSign;

  /// Mars sign
  final ZodiacSign? marsSign;

  /// Jupiter sign
  final ZodiacSign? jupiterSign;

  /// Saturn sign
  final ZodiacSign? saturnSign;

  /// Uranus sign
  final ZodiacSign? uranusSign;

  /// Neptune sign
  final ZodiacSign? neptuneSign;

  /// Pluto sign
  final ZodiacSign? plutoSign;

  /// Planetary positions
  final List<PlanetaryPosition> planetaryPositions;

  /// House cusps
  final List<HouseCusp>? houseCusps;

  /// Aspects
  final List<ChartAspect>? aspects;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [Chart] instance
  const Chart({
    required this.userId,
    required this.birthDate,
    this.birthTime,
    required this.birthLocation,
    this.birthLatitude,
    this.birthLongitude,
    required this.sunSign,
    required this.moonSign,
    this.ascendantSign,
    this.mercurySign,
    this.venusSign,
    this.marsSign,
    this.jupiterSign,
    this.saturnSign,
    this.uranusSign,
    this.neptuneSign,
    this.plutoSign,
    required this.planetaryPositions,
    this.houseCusps,
    this.aspects,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [Chart] instance from JSON
  factory Chart.fromJson(Map<String, dynamic> json) => _$ChartFromJson(json);

  /// Converts this [Chart] instance to JSON
  Map<String, dynamic> toJson() => _$ChartToJson(this);

  /// Creates a copy of this [Chart] instance with the given fields replaced
  Chart copyWith({
    String? userId,
    DateTime? birthDate,
    String? Function()? birthTime,
    String? birthLocation,
    double? Function()? birthLatitude,
    double? Function()? birthLongitude,
    ZodiacSign? sunSign,
    ZodiacSign? moonSign,
    ZodiacSign? Function()? ascendantSign,
    ZodiacSign? Function()? mercurySign,
    ZodiacSign? Function()? venusSign,
    ZodiacSign? Function()? marsSign,
    ZodiacSign? Function()? jupiterSign,
    ZodiacSign? Function()? saturnSign,
    ZodiacSign? Function()? uranusSign,
    ZodiacSign? Function()? neptuneSign,
    ZodiacSign? Function()? plutoSign,
    List<PlanetaryPosition>? planetaryPositions,
    List<HouseCusp>? Function()? houseCusps,
    List<ChartAspect>? Function()? aspects,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chart(
      userId: userId ?? this.userId,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime != null ? birthTime() : this.birthTime,
      birthLocation: birthLocation ?? this.birthLocation,
      birthLatitude: birthLatitude != null ? birthLatitude() : this.birthLatitude,
      birthLongitude: birthLongitude != null ? birthLongitude() : this.birthLongitude,
      sunSign: sunSign ?? this.sunSign,
      moonSign: moonSign ?? this.moonSign,
      ascendantSign: ascendantSign != null ? ascendantSign() : this.ascendantSign,
      mercurySign: mercurySign != null ? mercurySign() : this.mercurySign,
      venusSign: venusSign != null ? venusSign() : this.venusSign,
      marsSign: marsSign != null ? marsSign() : this.marsSign,
      jupiterSign: jupiterSign != null ? jupiterSign() : this.jupiterSign,
      saturnSign: saturnSign != null ? saturnSign() : this.saturnSign,
      uranusSign: uranusSign != null ? uranusSign() : this.uranusSign,
      neptuneSign: neptuneSign != null ? neptuneSign() : this.neptuneSign,
      plutoSign: plutoSign != null ? plutoSign() : this.plutoSign,
      planetaryPositions: planetaryPositions ?? this.planetaryPositions,
      houseCusps: houseCusps != null ? houseCusps() : this.houseCusps,
      aspects: aspects != null ? aspects() : this.aspects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty chart
  static final empty = Chart(
    userId: '',
    birthDate: _emptyDateTime,
    birthTime: null,
    birthLocation: '',
    birthLatitude: null,
    birthLongitude: null,
    sunSign: ZodiacSign.aries,
    moonSign: ZodiacSign.aries,
    ascendantSign: null,
    mercurySign: null,
    venusSign: null,
    marsSign: null,
    jupiterSign: null,
    saturnSign: null,
    uranusSign: null,
    neptuneSign: null,
    plutoSign: null,
    planetaryPositions: [],
    houseCusps: null,
    aspects: null,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == Chart.empty;

  /// Is not empty
  bool get isNotEmpty => this != Chart.empty;

  /// Get sun element
  Element get sunElement => _getElementForSign(sunSign);

  /// Get moon element
  Element get moonElement => _getElementForSign(moonSign);

  /// Get ascendant element
  Element? get ascendantElement => ascendantSign != null ? _getElementForSign(ascendantSign!) : null;

  /// Get sun modality
  Modality get sunModality => _getModalityForSign(sunSign);

  /// Get moon modality
  Modality get moonModality => _getModalityForSign(moonSign);

  /// Get ascendant modality
  Modality? get ascendantModality => ascendantSign != null ? _getModalityForSign(ascendantSign!) : null;

  /// Get element for sign
  static Element _getElementForSign(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
      case ZodiacSign.leo:
      case ZodiacSign.sagittarius:
        return Element.fire;
      case ZodiacSign.taurus:
      case ZodiacSign.virgo:
      case ZodiacSign.capricorn:
        return Element.earth;
      case ZodiacSign.gemini:
      case ZodiacSign.libra:
      case ZodiacSign.aquarius:
        return Element.air;
      case ZodiacSign.cancer:
      case ZodiacSign.scorpio:
      case ZodiacSign.pisces:
        return Element.water;
    }
  }

  /// Get modality for sign
  static Modality _getModalityForSign(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
      case ZodiacSign.cancer:
      case ZodiacSign.libra:
      case ZodiacSign.capricorn:
        return Modality.cardinal;
      case ZodiacSign.taurus:
      case ZodiacSign.leo:
      case ZodiacSign.scorpio:
      case ZodiacSign.aquarius:
        return Modality.fixed;
      case ZodiacSign.gemini:
      case ZodiacSign.virgo:
      case ZodiacSign.sagittarius:
      case ZodiacSign.pisces:
        return Modality.mutable;
    }
  }

  @override
  List<Object?> get props => [
        userId,
        birthDate,
        birthTime,
        birthLocation,
        birthLatitude,
        birthLongitude,
        sunSign,
        moonSign,
        ascendantSign,
        mercurySign,
        venusSign,
        marsSign,
        jupiterSign,
        saturnSign,
        uranusSign,
        neptuneSign,
        plutoSign,
        planetaryPositions,
        houseCusps,
        aspects,
        createdAt,
        updatedAt,
      ];
}
