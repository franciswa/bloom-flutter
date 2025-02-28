import 'package:flutter/foundation.dart';

import '../models/chart.dart';
import '../models/profile.dart';
import '../models/astrology.dart' as astrology;
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../services/service_registry.dart';

/// Chart provider
class ChartProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Profile provider
  final ProfileProvider _profileProvider;

  /// Current user chart
  Chart? _currentUserChart;

  /// Other user charts
  final Map<String, Chart> _otherUserCharts = {};

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Creates a new [ChartProvider] instance
  ChartProvider({
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
      await _loadCurrentUserChart();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load current user chart
  Future<void> _loadCurrentUserChart() async {
    if (_authProvider.currentUser == null ||
        _profileProvider.currentProfile == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    final profile = _profileProvider.currentProfile!;

    _currentUserChart =
        await ServiceRegistry.chartService.getChartByUserId(userId);

    // Create chart if it doesn't exist
    if (_currentUserChart == null && profile.birthTime != null) {
      final chart = Chart(
        userId: userId,
        birthDate: profile.birthDate,
        birthTime: profile.birthTime,
        birthLocation: profile.birthLocation,
        birthLatitude: profile.birthLatitude,
        birthLongitude: profile.birthLongitude,
        sunSign: _convertZodiacSign(
            profile.zodiacSign), // Use profile's zodiac sign as default
        moonSign: _convertZodiacSign(
            profile.zodiacSign), // Will be calculated by service
        planetaryPositions: [], // Will be populated by service
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _currentUserChart = await ServiceRegistry.chartService.createChart(chart);
    }
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

  /// Get current user chart
  Chart? get currentUserChart => _currentUserChart;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Has chart
  bool get hasChart => _currentUserChart != null;

  /// Get chart by user ID
  Future<Chart?> getChartByUserId(String userId) async {
    // Return from cache if available
    if (_otherUserCharts.containsKey(userId)) {
      return _otherUserCharts[userId];
    }

    _isLoading = true;
    notifyListeners();

    try {
      final chart = await ServiceRegistry.chartService.getChartByUserId(userId);

      // Cache the chart
      if (chart != null) {
        _otherUserCharts[userId] = chart;
      }

      _errorMessage = null;
      return chart;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create chart
  Future<void> createChart({
    required DateTime birthDate,
    required String birthTime,
    required double birthLatitude,
    required double birthLongitude,
    required String birthLocation,
  }) async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      // Create a new chart object
      final chart = Chart(
        userId: userId,
        birthDate: birthDate,
        birthTime: birthTime,
        birthLocation: birthLocation,
        birthLatitude: birthLatitude,
        birthLongitude: birthLongitude,
        sunSign: ZodiacSign.aries, // Will be calculated by service
        moonSign: ZodiacSign.aries, // Will be calculated by service
        planetaryPositions: [], // Will be populated by service
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Use the chart service to calculate and create the chart
      _currentUserChart =
          await ServiceRegistry.chartService.calculateNatalChart(
        userId: userId,
        birthDate: birthDate,
        birthTime: birthTime,
        birthLocation: birthLocation,
        birthLatitude: birthLatitude,
        birthLongitude: birthLongitude,
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

  /// Update chart
  Future<void> updateChart({
    required DateTime birthDate,
    required String birthTime,
    required double birthLatitude,
    required double birthLongitude,
    required String birthLocation,
  }) async {
    if (_currentUserChart == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create an updated chart object
      final updatedChart = _currentUserChart!.copyWith(
        birthDate: birthDate,
        birthTime: () => birthTime,
        birthLocation: birthLocation,
        birthLatitude: () => birthLatitude,
        birthLongitude: () => birthLongitude,
        updatedAt: DateTime.now(),
      );

      // Use the chart service to recalculate and update the chart
      _currentUserChart =
          await ServiceRegistry.chartService.calculateNatalChart(
        userId: updatedChart.userId,
        birthDate: birthDate,
        birthTime: birthTime,
        birthLocation: birthLocation,
        birthLatitude: birthLatitude,
        birthLongitude: birthLongitude,
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

  /// Delete chart
  Future<void> deleteChart() async {
    if (_currentUserChart == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.chartService.deleteChart(_currentUserChart!.userId);
      _currentUserChart = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create or update chart
  Future<void> createOrUpdateChart({
    required DateTime birthDate,
    required String birthTime,
    required double birthLatitude,
    required double birthLongitude,
    required String birthLocation,
  }) async {
    if (_currentUserChart == null) {
      await createChart(
        birthDate: birthDate,
        birthTime: birthTime,
        birthLatitude: birthLatitude,
        birthLongitude: birthLongitude,
        birthLocation: birthLocation,
      );
    } else {
      await updateChart(
        birthDate: birthDate,
        birthTime: birthTime,
        birthLatitude: birthLatitude,
        birthLongitude: birthLongitude,
        birthLocation: birthLocation,
      );
    }
  }

  /// Get sun sign
  ZodiacSign? getSunSign() {
    return _currentUserChart?.sunSign;
  }

  /// Get moon sign
  ZodiacSign? getMoonSign() {
    return _currentUserChart?.moonSign;
  }

  /// Get rising sign
  ZodiacSign? getRisingSign() {
    return _currentUserChart?.ascendantSign;
  }

  /// Get mercury sign
  ZodiacSign? getMercurySign() {
    return _currentUserChart?.mercurySign;
  }

  /// Get venus sign
  ZodiacSign? getVenusSign() {
    return _currentUserChart?.venusSign;
  }

  /// Get mars sign
  ZodiacSign? getMarsSign() {
    return _currentUserChart?.marsSign;
  }

  /// Get jupiter sign
  ZodiacSign? getJupiterSign() {
    return _currentUserChart?.jupiterSign;
  }

  /// Get saturn sign
  ZodiacSign? getSaturnSign() {
    return _currentUserChart?.saturnSign;
  }

  /// Get uranus sign
  ZodiacSign? getUranusSign() {
    return _currentUserChart?.uranusSign;
  }

  /// Get neptune sign
  ZodiacSign? getNeptuneSign() {
    return _currentUserChart?.neptuneSign;
  }

  /// Get pluto sign
  ZodiacSign? getPlutoSign() {
    return _currentUserChart?.plutoSign;
  }

  /// Helper method to convert from astrology.ZodiacSign to chart.ZodiacSign
  ZodiacSign _convertZodiacSign(astrology.ZodiacSign sign) {
    // Map from astrology.ZodiacSign to chart.ZodiacSign
    switch (sign) {
      case astrology.ZodiacSign.aries:
        return ZodiacSign.aries;
      case astrology.ZodiacSign.taurus:
        return ZodiacSign.taurus;
      case astrology.ZodiacSign.gemini:
        return ZodiacSign.gemini;
      case astrology.ZodiacSign.cancer:
        return ZodiacSign.cancer;
      case astrology.ZodiacSign.leo:
        return ZodiacSign.leo;
      case astrology.ZodiacSign.virgo:
        return ZodiacSign.virgo;
      case astrology.ZodiacSign.libra:
        return ZodiacSign.libra;
      case astrology.ZodiacSign.scorpio:
        return ZodiacSign.scorpio;
      case astrology.ZodiacSign.sagittarius:
        return ZodiacSign.sagittarius;
      case astrology.ZodiacSign.capricorn:
        return ZodiacSign.capricorn;
      case astrology.ZodiacSign.aquarius:
        return ZodiacSign.aquarius;
      case astrology.ZodiacSign.pisces:
        return ZodiacSign.pisces;
    }
  }

  /// Get dominant element
  Element? getDominantElement() {
    // Calculate dominant element based on planetary positions
    if (_currentUserChart == null ||
        _currentUserChart!.planetaryPositions.isEmpty) {
      return null;
    }

    final elementCounts = <Element, int>{};

    // Count elements from planetary positions
    for (final position in _currentUserChart!.planetaryPositions) {
      final element = _getElementForSign(position.sign);
      elementCounts[element] = (elementCounts[element] ?? 0) + 1;
    }

    // Find the most common element
    Element? dominantElement;
    int maxCount = 0;

    elementCounts.forEach((element, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantElement = element;
      }
    });

    return dominantElement;
  }

  /// Get element for sign
  Element _getElementForSign(ZodiacSign sign) {
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

  /// Get dominant modality
  Modality? getDominantModality() {
    // Calculate dominant modality based on planetary positions
    if (_currentUserChart == null ||
        _currentUserChart!.planetaryPositions.isEmpty) {
      return null;
    }

    final modalityCounts = <Modality, int>{};

    // Count modalities from planetary positions
    for (final position in _currentUserChart!.planetaryPositions) {
      final modality = _getModalityForSign(position.sign);
      modalityCounts[modality] = (modalityCounts[modality] ?? 0) + 1;
    }

    // Find the most common modality
    Modality? dominantModality;
    int maxCount = 0;

    modalityCounts.forEach((modality, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantModality = modality;
      }
    });

    return dominantModality;
  }

  /// Get modality for sign
  Modality _getModalityForSign(ZodiacSign sign) {
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

  /// Get dominant house
  House? getDominantHouse() {
    // Calculate dominant house based on planetary positions
    if (_currentUserChart == null ||
        _currentUserChart!.planetaryPositions.isEmpty) {
      return null;
    }

    final houseCounts = <House, int>{};

    // Count houses from planetary positions
    for (final position in _currentUserChart!.planetaryPositions) {
      houseCounts[position.house] = (houseCounts[position.house] ?? 0) + 1;
    }

    // Find the most common house
    House? dominantHouse;
    int maxCount = 0;

    houseCounts.forEach((house, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantHouse = house;
      }
    });

    return dominantHouse;
  }

  /// Get dominant planet
  Planet? getDominantPlanet() {
    // In a real app, this would be calculated based on aspects and other factors
    // For now, we'll return the sun as the dominant planet
    return _currentUserChart != null ? Planet.sun : null;
  }

  /// Get chart aspects
  List<ChartAspect>? getChartAspects() {
    return _currentUserChart?.aspects;
  }

  /// Get chart house cusps
  List<HouseCusp>? getChartHouseCusps() {
    return _currentUserChart?.houseCusps;
  }

  /// Get chart planetary positions
  List<PlanetaryPosition>? getChartPlanetaryPositions() {
    return _currentUserChart?.planetaryPositions;
  }

  /// Refresh current user chart
  Future<void> refreshCurrentUserChart() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadCurrentUserChart();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear other user charts cache
  void clearOtherUserChartsCache() {
    _otherUserCharts.clear();
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
