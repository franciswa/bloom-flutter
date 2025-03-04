import '../config/app_config.dart';
import '../models/chart.dart';
import 'supabase_service.dart';

/// Chart service
class ChartService {
  /// Table name
  static const String _tableName = AppConfig.supabaseChartsTable;

  /// Storage bucket name
  static const String _storageBucket =
      AppConfig.supabaseStorageChartImagesBucket;

  /// Get chart by user ID
  Future<Chart?> getChartByUserId(String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Chart.fromJson(response);
  }

  /// Create chart
  Future<Chart> createChart(Chart chart) async {
    final response = await SupabaseService.from(_tableName)
        .insert(chart.toJson())
        .select()
        .single();

    return Chart.fromJson(response);
  }

  /// Update chart
  Future<Chart> updateChart(Chart chart) async {
    final response = await SupabaseService.from(_tableName)
        .update(chart.toJson())
        .eq('user_id', chart.userId)
        .select()
        .single();

    return Chart.fromJson(response);
  }

  /// Delete chart
  Future<void> deleteChart(String userId) async {
    await SupabaseService.from(_tableName).delete().eq('user_id', userId);
  }

  /// Upload chart image
  Future<String> uploadChartImage({
    required String userId,
    required String filePath,
    required String fileName,
  }) async {
    final response = await SupabaseService.fromBucket(_storageBucket)
        .upload('$userId/$fileName', filePath);

    return SupabaseService.fromBucket(_storageBucket).getPublicUrl(response);
  }

  /// Delete chart image
  Future<void> deleteChartImage({
    required String userId,
    required String fileName,
  }) async {
    await SupabaseService.fromBucket(_storageBucket)
        .remove(['$userId/$fileName']);
  }

  /// Calculate natal chart
  Future<Chart> calculateNatalChart({
    required String userId,
    required DateTime birthDate,
    required String birthTime,
    required String birthLocation,
    required double birthLatitude,
    required double birthLongitude,
  }) async {
    // Calculate sun sign based on birth date
    final sunSign = _calculateZodiacSign(birthDate);

    // Calculate moon sign (simplified - in a real app, this would use ephemeris data)
    final moonSign = _calculateMoonSign(birthDate, birthTime);

    // Calculate ascendant sign (simplified - in a real app, this would use location and time)
    final ascendantSign = _calculateAscendantSign(
        birthDate, birthTime, birthLatitude, birthLongitude);

    // Calculate planetary positions (simplified)
    final planetaryPositions = _calculatePlanetaryPositions(
        birthDate, birthTime, birthLatitude, birthLongitude);

    // Create chart
    final chart = Chart(
      userId: userId,
      birthDate: birthDate,
      birthTime: birthTime,
      birthLocation: birthLocation,
      birthLatitude: birthLatitude,
      birthLongitude: birthLongitude,
      sunSign: sunSign,
      moonSign: moonSign,
      ascendantSign: ascendantSign,
      planetaryPositions: planetaryPositions,
      houseCusps: null, // In a real app, this would be calculated
      aspects: null, // In a real app, this would be calculated
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save chart to database
    return await createChart(chart);
  }

  /// Calculate zodiac sign from birth date
  ZodiacSign _calculateZodiacSign(DateTime birthDate) {
    final month = birthDate.month;
    final day = birthDate.day;

    // Calculate date value (month * 100 + day) for easy comparison
    final dateValue = month * 100 + day;

    if (dateValue >= 321 && dateValue <= 419) {
      return ZodiacSign.aries;
    } else if (dateValue >= 420 && dateValue <= 520) {
      return ZodiacSign.taurus;
    } else if (dateValue >= 521 && dateValue <= 620) {
      return ZodiacSign.gemini;
    } else if (dateValue >= 621 && dateValue <= 722) {
      return ZodiacSign.cancer;
    } else if (dateValue >= 723 && dateValue <= 822) {
      return ZodiacSign.leo;
    } else if (dateValue >= 823 && dateValue <= 922) {
      return ZodiacSign.virgo;
    } else if (dateValue >= 923 && dateValue <= 1022) {
      return ZodiacSign.libra;
    } else if (dateValue >= 1023 && dateValue <= 1121) {
      return ZodiacSign.scorpio;
    } else if (dateValue >= 1122 && dateValue <= 1221) {
      return ZodiacSign.sagittarius;
    } else if ((dateValue >= 1222 && dateValue <= 1231) ||
        (dateValue >= 101 && dateValue <= 119)) {
      return ZodiacSign.capricorn;
    } else if (dateValue >= 120 && dateValue <= 218) {
      return ZodiacSign.aquarius;
    } else {
      return ZodiacSign.pisces;
    }
  }

  /// Calculate moon sign (simplified)
  ZodiacSign _calculateMoonSign(DateTime birthDate, String birthTime) {
    // In a real app, this would use ephemeris data
    // For now, we'll use a simplified algorithm based on birth date

    // Parse birth time
    final timeParts = birthTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Adjust birth date based on time
    final adjustedDate = birthDate.add(Duration(hours: hour, minutes: minute));

    // Calculate moon sign (simplified - moon moves roughly one sign every 2.5 days)
    final dayOfYear =
        adjustedDate.difference(DateTime(adjustedDate.year, 1, 1)).inDays;
    final moonSignIndex = (dayOfYear ~/ 2.5) % 12;

    return ZodiacSign.values[moonSignIndex];
  }

  /// Calculate ascendant sign (simplified)
  ZodiacSign _calculateAscendantSign(
      DateTime birthDate, String birthTime, double latitude, double longitude) {
    // In a real app, this would use location and time
    // For now, we'll use a simplified algorithm based on birth time

    // Parse birth time
    final timeParts = birthTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Calculate ascendant sign (simplified - ascendant changes roughly every 2 hours)
    final ascendantSignIndex = ((hour * 60 + minute) ~/ 120) % 12;

    return ZodiacSign.values[ascendantSignIndex];
  }

  /// Calculate planetary positions (simplified)
  List<PlanetaryPosition> _calculatePlanetaryPositions(
      DateTime birthDate, String birthTime, double latitude, double longitude) {
    // In a real app, this would use ephemeris data
    // For now, we'll return simplified positions

    final sunSign = _calculateZodiacSign(birthDate);
    final moonSign = _calculateMoonSign(birthDate, birthTime);
    final ascendantSign =
        _calculateAscendantSign(birthDate, birthTime, latitude, longitude);

    // Calculate other planets (simplified)
    final mercurySign = _calculateAdjacentSign(sunSign, 1);
    final venusSign = _calculateAdjacentSign(sunSign, 2);
    final marsSign = _calculateAdjacentSign(moonSign, 1);
    final jupiterSign = _calculateAdjacentSign(ascendantSign, 2);
    final saturnSign = _calculateAdjacentSign(ascendantSign, 3);
    final uranusSign = _calculateAdjacentSign(jupiterSign, 1);
    final neptuneSign = _calculateAdjacentSign(saturnSign, 2);
    final plutoSign = _calculateAdjacentSign(neptuneSign, 1);

    return [
      PlanetaryPosition(
        planet: Planet.sun,
        sign: sunSign,
        degree: 15.0, // Simplified
        house: House.first, // Simplified
        isRetrograde: false,
      ),
      PlanetaryPosition(
        planet: Planet.moon,
        sign: moonSign,
        degree: 10.0, // Simplified
        house: House.second, // Simplified
        isRetrograde: false,
      ),
      PlanetaryPosition(
        planet: Planet.mercury,
        sign: mercurySign,
        degree: 5.0, // Simplified
        house: House.third, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.mercury),
      ),
      PlanetaryPosition(
        planet: Planet.venus,
        sign: venusSign,
        degree: 20.0, // Simplified
        house: House.fourth, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.venus),
      ),
      PlanetaryPosition(
        planet: Planet.mars,
        sign: marsSign,
        degree: 25.0, // Simplified
        house: House.fifth, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.mars),
      ),
      PlanetaryPosition(
        planet: Planet.jupiter,
        sign: jupiterSign,
        degree: 12.0, // Simplified
        house: House.sixth, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.jupiter),
      ),
      PlanetaryPosition(
        planet: Planet.saturn,
        sign: saturnSign,
        degree: 8.0, // Simplified
        house: House.seventh, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.saturn),
      ),
      PlanetaryPosition(
        planet: Planet.uranus,
        sign: uranusSign,
        degree: 3.0, // Simplified
        house: House.eighth, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.uranus),
      ),
      PlanetaryPosition(
        planet: Planet.neptune,
        sign: neptuneSign,
        degree: 18.0, // Simplified
        house: House.ninth, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.neptune),
      ),
      PlanetaryPosition(
        planet: Planet.pluto,
        sign: plutoSign,
        degree: 22.0, // Simplified
        house: House.tenth, // Simplified
        isRetrograde: _isRetrograde(birthDate, Planet.pluto),
      ),
    ];
  }

  /// Calculate adjacent sign
  ZodiacSign _calculateAdjacentSign(ZodiacSign sign, int offset) {
    final signIndex = ZodiacSign.values.indexOf(sign);
    final newIndex = (signIndex + offset) % 12;
    return ZodiacSign.values[newIndex];
  }

  /// Check if planet is retrograde (simplified)
  bool _isRetrograde(DateTime birthDate, Planet planet) {
    // In a real app, this would use ephemeris data
    // For now, we'll use a simplified algorithm based on birth date

    final dayOfYear =
        birthDate.difference(DateTime(birthDate.year, 1, 1)).inDays;

    switch (planet) {
      case Planet.mercury:
        // Mercury is retrograde roughly 3 times a year for about 3 weeks
        return (dayOfYear % 120) < 21;
      case Planet.venus:
        // Venus is retrograde roughly every 18 months for about 6 weeks
        return (dayOfYear % 540) < 42;
      case Planet.mars:
        // Mars is retrograde roughly every 26 months for about 2.5 months
        return (dayOfYear % 780) < 75;
      case Planet.jupiter:
        // Jupiter is retrograde roughly 4 months each year
        return (dayOfYear % 365) < 120;
      case Planet.saturn:
        // Saturn is retrograde roughly 4.5 months each year
        return (dayOfYear % 365) < 135;
      case Planet.uranus:
        // Uranus is retrograde roughly 5 months each year
        return (dayOfYear % 365) < 150;
      case Planet.neptune:
        // Neptune is retrograde roughly 5 months each year
        return (dayOfYear % 365) < 150;
      case Planet.pluto:
        // Pluto is retrograde roughly 5 months each year
        return (dayOfYear % 365) < 150;
      default:
        return false;
    }
  }

  /// Get element for sign
  Element getElementForSign(ZodiacSign sign) {
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
  Modality getModalityForSign(ZodiacSign sign) {
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

  /// Get ruling planet for sign
  Planet getRulingPlanetForSign(ZodiacSign sign) {
    switch (sign) {
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
        return Planet.pluto; // Modern ruler (traditionally Mars)
      case ZodiacSign.sagittarius:
        return Planet.jupiter;
      case ZodiacSign.capricorn:
        return Planet.saturn;
      case ZodiacSign.aquarius:
        return Planet.uranus; // Modern ruler (traditionally Saturn)
      case ZodiacSign.pisces:
        return Planet.neptune; // Modern ruler (traditionally Jupiter)
    }
  }
}
