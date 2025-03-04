import 'package:json_annotation/json_annotation.dart';

/// Zodiac sign enum
@JsonEnum()
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
@JsonEnum()
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
@JsonEnum()
enum Modality {
  /// Cardinal
  cardinal,

  /// Fixed
  fixed,

  /// Mutable
  mutable,
}

/// House enum
@JsonEnum()
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

/// Planet enum
@JsonEnum()
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

  /// Chiron
  chiron,

  /// North Node
  northNode,

  /// South Node
  southNode,
}

/// Aspect enum
@JsonEnum()
enum Aspect {
  /// Conjunction
  conjunction,

  /// Sextile
  sextile,

  /// Square
  square,

  /// Trine
  trine,

  /// Opposition
  opposition,
}

/// Extension for ZodiacSign
extension ZodiacSignExtension on ZodiacSign {
  /// Get zodiac sign name
  String get name {
    switch (this) {
      case ZodiacSign.aries:
        return 'Aries';
      case ZodiacSign.taurus:
        return 'Taurus';
      case ZodiacSign.gemini:
        return 'Gemini';
      case ZodiacSign.cancer:
        return 'Cancer';
      case ZodiacSign.leo:
        return 'Leo';
      case ZodiacSign.virgo:
        return 'Virgo';
      case ZodiacSign.libra:
        return 'Libra';
      case ZodiacSign.scorpio:
        return 'Scorpio';
      case ZodiacSign.sagittarius:
        return 'Sagittarius';
      case ZodiacSign.capricorn:
        return 'Capricorn';
      case ZodiacSign.aquarius:
        return 'Aquarius';
      case ZodiacSign.pisces:
        return 'Pisces';
    }
  }

  /// Get zodiac sign symbol
  String get symbol {
    switch (this) {
      case ZodiacSign.aries:
        return '♈';
      case ZodiacSign.taurus:
        return '♉';
      case ZodiacSign.gemini:
        return '♊';
      case ZodiacSign.cancer:
        return '♋';
      case ZodiacSign.leo:
        return '♌';
      case ZodiacSign.virgo:
        return '♍';
      case ZodiacSign.libra:
        return '♎';
      case ZodiacSign.scorpio:
        return '♏';
      case ZodiacSign.sagittarius:
        return '♐';
      case ZodiacSign.capricorn:
        return '♑';
      case ZodiacSign.aquarius:
        return '♒';
      case ZodiacSign.pisces:
        return '♓';
    }
  }

  /// Get zodiac sign element
  Element get element {
    switch (this) {
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

  /// Get zodiac sign modality
  Modality get modality {
    switch (this) {
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

  /// Get zodiac sign ruling planet
  Planet get rulingPlanet {
    switch (this) {
      case ZodiacSign.aries:
        return Planet.mars;
      case ZodiacSign.taurus:
        return Planet.venus;
      case ZodiacSign.gemini:
        return Planet.mercury;
      case ZodiacSign.cancer:
        return Planet.moon;
      case ZodiacSign.leo:
        return Planet.sun;
      case ZodiacSign.virgo:
        return Planet.mercury;
      case ZodiacSign.libra:
        return Planet.venus;
      case ZodiacSign.scorpio:
        return Planet.pluto;
      case ZodiacSign.sagittarius:
        return Planet.jupiter;
      case ZodiacSign.capricorn:
        return Planet.saturn;
      case ZodiacSign.aquarius:
        return Planet.uranus;
      case ZodiacSign.pisces:
        return Planet.neptune;
    }
  }
}

/// Extension for Element
extension ElementExtension on Element {
  /// Get element name
  String get name {
    switch (this) {
      case Element.fire:
        return 'Fire';
      case Element.earth:
        return 'Earth';
      case Element.air:
        return 'Air';
      case Element.water:
        return 'Water';
    }
  }

  /// Get element symbol
  String get symbol {
    switch (this) {
      case Element.fire:
        return '🔥';
      case Element.earth:
        return '🌍';
      case Element.air:
        return '💨';
      case Element.water:
        return '💧';
    }
  }
}

/// Extension for Modality
extension ModalityExtension on Modality {
  /// Get modality name
  String get name {
    switch (this) {
      case Modality.cardinal:
        return 'Cardinal';
      case Modality.fixed:
        return 'Fixed';
      case Modality.mutable:
        return 'Mutable';
    }
  }
}

/// Extension for House
extension HouseExtension on House {
  /// Get house name
  String get name {
    switch (this) {
      case House.first:
        return '1st House';
      case House.second:
        return '2nd House';
      case House.third:
        return '3rd House';
      case House.fourth:
        return '4th House';
      case House.fifth:
        return '5th House';
      case House.sixth:
        return '6th House';
      case House.seventh:
        return '7th House';
      case House.eighth:
        return '8th House';
      case House.ninth:
        return '9th House';
      case House.tenth:
        return '10th House';
      case House.eleventh:
        return '11th House';
      case House.twelfth:
        return '12th House';
    }
  }
}

/// Extension for Planet
extension PlanetExtension on Planet {
  /// Get planet name
  String get name {
    switch (this) {
      case Planet.sun:
        return 'Sun';
      case Planet.moon:
        return 'Moon';
      case Planet.mercury:
        return 'Mercury';
      case Planet.venus:
        return 'Venus';
      case Planet.mars:
        return 'Mars';
      case Planet.jupiter:
        return 'Jupiter';
      case Planet.saturn:
        return 'Saturn';
      case Planet.uranus:
        return 'Uranus';
      case Planet.neptune:
        return 'Neptune';
      case Planet.pluto:
        return 'Pluto';
      case Planet.chiron:
        return 'Chiron';
      case Planet.northNode:
        return 'North Node';
      case Planet.southNode:
        return 'South Node';
    }
  }

  /// Get planet symbol
  String get symbol {
    switch (this) {
      case Planet.sun:
        return '☉';
      case Planet.moon:
        return '☽';
      case Planet.mercury:
        return '☿';
      case Planet.venus:
        return '♀';
      case Planet.mars:
        return '♂';
      case Planet.jupiter:
        return '♃';
      case Planet.saturn:
        return '♄';
      case Planet.uranus:
        return '♅';
      case Planet.neptune:
        return '♆';
      case Planet.pluto:
        return '♇';
      case Planet.chiron:
        return '⚷';
      case Planet.northNode:
        return '☊';
      case Planet.southNode:
        return '☋';
    }
  }
}

/// Extension for Aspect
extension AspectExtension on Aspect {
  /// Get aspect name
  String get name {
    switch (this) {
      case Aspect.conjunction:
        return 'Conjunction';
      case Aspect.sextile:
        return 'Sextile';
      case Aspect.square:
        return 'Square';
      case Aspect.trine:
        return 'Trine';
      case Aspect.opposition:
        return 'Opposition';
    }
  }

  /// Get aspect symbol
  String get symbol {
    switch (this) {
      case Aspect.conjunction:
        return '☌';
      case Aspect.sextile:
        return '⚹';
      case Aspect.square:
        return '□';
      case Aspect.trine:
        return '△';
      case Aspect.opposition:
        return '☍';
    }
  }

  /// Get aspect angle
  int get angle {
    switch (this) {
      case Aspect.conjunction:
        return 0;
      case Aspect.sextile:
        return 60;
      case Aspect.square:
        return 90;
      case Aspect.trine:
        return 120;
      case Aspect.opposition:
        return 180;
    }
  }
}

/// Chart house model
class ChartHouse {
  /// House
  final House house;

  /// Sign
  final ZodiacSign sign;

  /// Cusp degree
  final double cuspDegree;

  /// Creates a new [ChartHouse] instance
  const ChartHouse({
    required this.house,
    required this.sign,
    required this.cuspDegree,
  });
}

/// Chart planet model
class ChartPlanet {
  /// Planet
  final Planet planet;

  /// Sign
  final ZodiacSign sign;

  /// House
  final House house;

  /// Degree
  final double degree;

  /// Is retrograde
  final bool isRetrograde;

  /// Creates a new [ChartPlanet] instance
  const ChartPlanet({
    required this.planet,
    required this.sign,
    required this.house,
    required this.degree,
    required this.isRetrograde,
  });
}

/// Chart aspect model
class ChartAspect {
  /// First planet
  final Planet firstPlanet;

  /// Second planet
  final Planet secondPlanet;

  /// Aspect
  final Aspect aspect;

  /// Orb
  final double orb;

  /// Creates a new [ChartAspect] instance
  const ChartAspect({
    required this.firstPlanet,
    required this.secondPlanet,
    required this.aspect,
    required this.orb,
  });
}
