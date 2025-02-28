import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/chart.dart';
import '../models/compatibility.dart';
import '../models/compatibility_questionnaire.dart';
import 'chart_service.dart';
import 'questionnaire_service.dart';
import 'service_registry.dart';
import 'supabase_service.dart';

/// Compatibility service
class CompatibilityService {
  /// Table name
  static const String _tableName = AppConfig.supabaseCompatibilityTable;
  
  /// Chart service
  final ChartService _chartService;
  
  /// Questionnaire service
  final QuestionnaireService _questionnaireService;
  
  /// Creates a new [CompatibilityService] instance
  CompatibilityService({
    ChartService? chartService,
    QuestionnaireService? questionnaireService,
  })  : _chartService = chartService ?? ChartService(),
        _questionnaireService = questionnaireService ?? QuestionnaireService();

  /// Get compatibility by user IDs
  Future<Compatibility?> getCompatibilityByUserIds(String userId1, String userId2) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .or('first_user_id.eq.$userId1,first_user_id.eq.$userId2')
        .or('second_user_id.eq.$userId1,second_user_id.eq.$userId2')
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Compatibility.fromJson(response);
  }

  /// Create compatibility
  Future<Compatibility> createCompatibility(Compatibility compatibility) async {
    final response = await SupabaseService.from(_tableName)
        .insert(compatibility.toJson())
        .select()
        .single();

    return Compatibility.fromJson(response);
  }

  /// Update compatibility
  Future<Compatibility> updateCompatibility(Compatibility compatibility) async {
    final response = await SupabaseService.from(_tableName)
        .update(compatibility.toJson())
        .filter('first_user_id', 'eq', compatibility.firstUserId)
        .filter('second_user_id', 'eq', compatibility.secondUserId)
        .select()
        .single();

    return Compatibility.fromJson(response);
  }

  /// Delete compatibility
  Future<void> deleteCompatibility(String userId1, String userId2) async {
    await SupabaseService.from(_tableName)
        .delete()
        .filter('first_user_id', 'eq', userId1)
        .filter('second_user_id', 'eq', userId2);
  }

  /// Calculate compatibility
  Future<Compatibility> calculateCompatibility(String userId1, String userId2) async {
    // Get charts
    final chart1 = await _chartService.getChartByUserId(userId1);
    final chart2 = await _chartService.getChartByUserId(userId2);
    
    if (chart1 == null || chart2 == null) {
      throw Exception('Charts not found');
    }
    
    // Calculate compatibility
    final compatibility = await calculateCompatibilityFromCharts(chart1, chart2);
    
    // Save compatibility to database
    return await createCompatibility(compatibility);
  }
  
  /// Calculate compatibility from charts
  Future<Compatibility> calculateCompatibilityFromCharts(Chart chart1, Chart chart2) async {
    // Calculate astrological compatibility (50% of total)
    final astrologicalScore = await _calculateAstrologicalScore(chart1, chart2);
    
    // Calculate questionnaire compatibility (50% of total)
    final questionnaireScore = await _calculateQuestionnaireScore(chart1.userId, chart2.userId);
    
    // Calculate overall score (weighted average)
    final overallScore = ((astrologicalScore * 0.5) + (questionnaireScore * 0.5)).round();
    
    // Calculate overall level
    final overallLevel = Compatibility.getCompatibilityLevelFromScore(overallScore);
    
    // Calculate categories
    final categories = await _calculateCategories(chart1, chart2);
    
    // Calculate aspects
    final aspects = await _calculateAspects(chart1, chart2);
    
    // Generate report
    final report = await _generateCompatibilityReport(
      chart1,
      chart2,
      astrologicalScore,
      questionnaireScore,
      overallScore,
      overallLevel,
      categories,
      aspects,
    );
    
    // Create compatibility
    return Compatibility(
      firstUserId: chart1.userId,
      secondUserId: chart2.userId,
      overallScore: overallScore,
      overallLevel: overallLevel,
      overallDescription: _getOverallDescription(overallLevel, chart1.sunSign, chart2.sunSign),
      astrologicalScore: astrologicalScore,
      questionnaireScore: questionnaireScore,
      report: report,
      categories: categories,
      aspects: aspects,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  /// Calculate astrological score
  Future<int> _calculateAstrologicalScore(Chart chart1, Chart chart2) async {
    // Calculate sun sign compatibility (25%)
    final sunSignScore = _calculateSunSignCompatibility(chart1.sunSign, chart2.sunSign);
    
    // Calculate moon sign compatibility (25%)
    final moonSignScore = _calculateMoonSignCompatibility(chart1.moonSign, chart2.moonSign);
    
    // Calculate ascendant compatibility (15%)
    final ascendantScore = chart1.ascendantSign != null && chart2.ascendantSign != null
        ? _calculateAscendantCompatibility(chart1.ascendantSign!, chart2.ascendantSign!)
        : 50;
    
    // Calculate element compatibility (20%)
    final elementScore = _calculateElementCompatibility(chart1, chart2);
    
    // Calculate aspect compatibility (15%)
    final aspectScore = _calculateAspectCompatibility(chart1, chart2);
    
    // Calculate overall score
    return (sunSignScore * 0.25 + moonSignScore * 0.25 + ascendantScore * 0.15 + elementScore * 0.2 + aspectScore * 0.15).round();
  }
  
  /// Calculate questionnaire score
  Future<int> _calculateQuestionnaireScore(String userId1, String userId2) async {
    try {
      // Get questionnaire result
      final questionnaireResult = await _questionnaireService.getQuestionnaireResult(userId1, userId2);
      
      // If result exists, return it
      if (questionnaireResult != null) {
        return questionnaireResult.overallScore;
      }
      
      // Calculate new result
      final newResult = await _questionnaireService.calculateQuestionnaireCompatibility(userId1, userId2);
      return newResult.overallScore;
    } catch (e) {
      // If questionnaire not completed, return default score
      return 50;
    }
  }
  
  /// Calculate sun sign compatibility
  int _calculateSunSignCompatibility(ZodiacSign sign1, ZodiacSign sign2) {
    // Get elements
    final element1 = _chartService.getElementForSign(sign1);
    final element2 = _chartService.getElementForSign(sign2);
    
    // Get modalities
    final modality1 = _chartService.getModalityForSign(sign1);
    final modality2 = _chartService.getModalityForSign(sign2);
    
    // Calculate element compatibility (0-100)
    final elementScore = _calculateElementCompatibilityScore(element1, element2);
    
    // Calculate modality compatibility (0-100)
    final modalityScore = _calculateModalityCompatibilityScore(modality1, modality2);
    
    // Calculate sign compatibility (0-100)
    final signScore = _calculateSignCompatibilityScore(sign1, sign2);
    
    // Calculate overall score (weighted average)
    return (elementScore * 0.4 + modalityScore * 0.3 + signScore * 0.3).round();
  }
  
  /// Calculate moon sign compatibility
  int _calculateMoonSignCompatibility(ZodiacSign sign1, ZodiacSign sign2) {
    // Similar to sun sign compatibility but with different weights
    return _calculateSunSignCompatibility(sign1, sign2);
  }
  
  /// Calculate ascendant compatibility
  int _calculateAscendantCompatibility(ZodiacSign sign1, ZodiacSign sign2) {
    // Similar to sun sign compatibility but with different weights
    return _calculateSunSignCompatibility(sign1, sign2);
  }
  
  /// Calculate element compatibility
  int _calculateElementCompatibility(Chart chart1, Chart chart2) {
    // Count elements in each chart
    final elementCounts1 = _countElements(chart1);
    final elementCounts2 = _countElements(chart2);
    
    // Calculate element compatibility scores
    int totalScore = 0;
    int totalWeight = 0;
    
    // Compare all element combinations
    for (final element1 in Element.values) {
      for (final element2 in Element.values) {
        final score = _calculateElementCompatibilityScore(element1, element2);
        final weight = elementCounts1[element1]! * elementCounts2[element2]!;
        totalScore += score * weight;
        totalWeight += weight;
      }
    }
    
    // Calculate overall score
    return totalWeight > 0 ? (totalScore / totalWeight).round() : 50;
  }
  
  /// Count elements in chart
  Map<Element, int> _countElements(Chart chart) {
    final elementCounts = {
      Element.fire: 0,
      Element.earth: 0,
      Element.air: 0,
      Element.water: 0,
    };
    
    // Count sun sign element
    final sunElement = _chartService.getElementForSign(chart.sunSign);
    elementCounts[sunElement] = elementCounts[sunElement]! + 3; // Sun has higher weight
    
    // Count moon sign element
    final moonElement = _chartService.getElementForSign(chart.moonSign);
    elementCounts[moonElement] = elementCounts[moonElement]! + 2; // Moon has higher weight
    
    // Count ascendant element
    if (chart.ascendantSign != null) {
      final ascendantElement = _chartService.getElementForSign(chart.ascendantSign!);
      elementCounts[ascendantElement] = elementCounts[ascendantElement]! + 2; // Ascendant has higher weight
    }
    
    // Count other planets
    for (final position in chart.planetaryPositions) {
      if (position.planet != Planet.sun && position.planet != Planet.moon) {
        final element = _chartService.getElementForSign(position.sign);
        elementCounts[element] = elementCounts[element]! + 1;
      }
    }
    
    return elementCounts;
  }
  
  /// Calculate aspect compatibility
  int _calculateAspectCompatibility(Chart chart1, Chart chart2) {
    // Simplified aspect compatibility calculation
    return 70; // Default score
  }
  
  /// Calculate element compatibility score
  int _calculateElementCompatibilityScore(Element element1, Element element2) {
    if (element1 == element2) {
      return 80; // Same element = good compatibility
    }
    
    // Fire and Air are compatible
    if ((element1 == Element.fire && element2 == Element.air) ||
        (element1 == Element.air && element2 == Element.fire)) {
      return 85;
    }
    
    // Earth and Water are compatible
    if ((element1 == Element.earth && element2 == Element.water) ||
        (element1 == Element.water && element2 == Element.earth)) {
      return 85;
    }
    
    // Fire and Earth can be challenging
    if ((element1 == Element.fire && element2 == Element.earth) ||
        (element1 == Element.earth && element2 == Element.fire)) {
      return 45;
    }
    
    // Fire and Water can be challenging
    if ((element1 == Element.fire && element2 == Element.water) ||
        (element1 == Element.water && element2 == Element.fire)) {
      return 40;
    }
    
    // Air and Earth can be challenging
    if ((element1 == Element.air && element2 == Element.earth) ||
        (element1 == Element.earth && element2 == Element.air)) {
      return 45;
    }
    
    // Air and Water can be moderately compatible
    if ((element1 == Element.air && element2 == Element.water) ||
        (element1 == Element.water && element2 == Element.air)) {
      return 60;
    }
    
    return 50; // Default
  }
  
  /// Calculate modality compatibility score
  int _calculateModalityCompatibilityScore(Modality modality1, Modality modality2) {
    if (modality1 == modality2) {
      return 70; // Same modality = good compatibility but can be competitive
    }
    
    // Cardinal and Mutable can work well together
    if ((modality1 == Modality.cardinal && modality2 == Modality.mutable) ||
        (modality1 == Modality.mutable && modality2 == Modality.cardinal)) {
      return 80;
    }
    
    // Fixed and Mutable can balance each other
    if ((modality1 == Modality.fixed && modality2 == Modality.mutable) ||
        (modality1 == Modality.mutable && modality2 == Modality.fixed)) {
      return 75;
    }
    
    // Cardinal and Fixed can be challenging
    if ((modality1 == Modality.cardinal && modality2 == Modality.fixed) ||
        (modality1 == Modality.fixed && modality2 == Modality.cardinal)) {
      return 60;
    }
    
    return 50; // Default
  }
  
  /// Calculate sign compatibility score
  int _calculateSignCompatibilityScore(ZodiacSign sign1, ZodiacSign sign2) {
    // Same sign
    if (sign1 == sign2) {
      return 75;
    }
    
    // Get elements
    final element1 = _chartService.getElementForSign(sign1);
    final element2 = _chartService.getElementForSign(sign2);
    
    // Get modalities
    final modality1 = _chartService.getModalityForSign(sign1);
    final modality2 = _chartService.getModalityForSign(sign2);
    
    // Calculate base score from element and modality
    int baseScore = (_calculateElementCompatibilityScore(element1, element2) * 0.6 +
                    _calculateModalityCompatibilityScore(modality1, modality2) * 0.4).round();
    
    return baseScore;
  }
  
  /// Calculate compatibility categories
  Future<List<CompatibilityCategory>> _calculateCategories(Chart chart1, Chart chart2) async {
    // Get questionnaire result
    QuestionnaireResult? questionnaireResult;
    try {
      questionnaireResult = await _questionnaireService.getQuestionnaireResult(chart1.userId, chart2.userId);
    } catch (e) {
      // Ignore errors
    }
    
    // Create categories
    final categories = <CompatibilityCategory>[];
    
    // Emotional compatibility (based on Moon signs)
    final emotionalScore = _calculateMoonSignCompatibility(chart1.moonSign, chart2.moonSign);
    final emotionalLevel = Compatibility.getCompatibilityLevelFromScore(emotionalScore);
    categories.add(CompatibilityCategory(
      name: 'Emotional',
      score: emotionalScore,
      level: emotionalLevel,
      description: _getEmotionalDescription(emotionalLevel, chart1.moonSign, chart2.moonSign),
    ));
    
    // Communication compatibility (based on Mercury signs)
    final communicationScore = chart1.mercurySign != null && chart2.mercurySign != null
        ? _calculateSunSignCompatibility(chart1.mercurySign!, chart2.mercurySign!)
        : 60;
    final communicationLevel = Compatibility.getCompatibilityLevelFromScore(communicationScore);
    categories.add(CompatibilityCategory(
      name: 'Communication',
      score: communicationScore,
      level: communicationLevel,
      description: _getCommunicationDescription(communicationLevel, chart1, chart2),
    ));
    
    // Physical compatibility (based on Mars and Venus signs)
    final physicalScore = chart1.marsSign != null && chart2.venusSign != null && chart1.venusSign != null && chart2.marsSign != null
        ? (_calculateSunSignCompatibility(chart1.marsSign!, chart2.venusSign!) +
           _calculateSunSignCompatibility(chart1.venusSign!, chart2.marsSign!)) ~/ 2
        : 65;
    final physicalLevel = Compatibility.getCompatibilityLevelFromScore(physicalScore);
    categories.add(CompatibilityCategory(
      name: 'Physical',
      score: physicalScore,
      level: physicalLevel,
      description: _getPhysicalDescription(physicalLevel, chart1, chart2),
    ));
    
    // Intellectual compatibility (based on Mercury and Sun signs)
    final intellectualScore = chart1.mercurySign != null && chart2.mercurySign != null
        ? (_calculateSunSignCompatibility(chart1.mercurySign!, chart2.mercurySign!) +
           _calculateSunSignCompatibility(chart1.sunSign, chart2.sunSign)) ~/ 2
        : 60;
    final intellectualLevel = Compatibility.getCompatibilityLevelFromScore(intellectualScore);
    categories.add(CompatibilityCategory(
      name: 'Intellectual',
      score: intellectualScore,
      level: intellectualLevel,
      description: _getIntellectualDescription(intellectualLevel, chart1, chart2),
    ));
    
    // Spiritual compatibility (based on Jupiter and Neptune signs)
    final spiritualScore = chart1.jupiterSign != null && chart2.jupiterSign != null && chart1.neptuneSign != null && chart2.neptuneSign != null
        ? (_calculateSunSignCompatibility(chart1.jupiterSign!, chart2.jupiterSign!) +
           _calculateSunSignCompatibility(chart1.neptuneSign!, chart2.neptuneSign!)) ~/ 2
        : 60;
    final spiritualLevel = Compatibility.getCompatibilityLevelFromScore(spiritualScore);
    categories.add(CompatibilityCategory(
      name: 'Spiritual',
      score: spiritualScore,
      level: spiritualLevel,
      description: _getSpiritualDescription(spiritualLevel, chart1, chart2),
    ));
    
    // Add questionnaire categories if available
    if (questionnaireResult != null) {
      for (final category in QuestionnaireCategory.values) {
        final score = questionnaireResult.categoryScores[category] ?? 50;
        final level = Compatibility.getCompatibilityLevelFromScore(score);
        
        String name;
        String description;
        
        switch (category) {
          case QuestionnaireCategory.personalValues:
            name = 'Values';
            description = 'Your compatibility in terms of values and beliefs is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
            break;
          case QuestionnaireCategory.lifestyle:
            name = 'Lifestyle';
            description = 'Your compatibility in terms of lifestyle preferences is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
            break;
          case QuestionnaireCategory.communication:
            name = 'Communication Style';
            description = 'Your compatibility in terms of communication style is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
            break;
          case QuestionnaireCategory.intimacy:
            name = 'Intimacy';
            description = 'Your compatibility in terms of intimacy preferences is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
            break;
          case QuestionnaireCategory.futureGoals:
            name = 'Future Goals';
            description = 'Your compatibility in terms of future goals is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
            break;
        }
        
        categories.add(CompatibilityCategory(
          name: name,
          score: score,
          level: level,
          description: description,
        ));
      }
    }
    
    return categories;
  }
  
  /// Calculate compatibility aspects
  Future<List<CompatibilityAspect>> _calculateAspects(Chart chart1, Chart chart2) async {
    // Simplified aspects
    return [
      CompatibilityAspect(
        aspect: Aspect.conjunction,
        firstUserPlanet: Planet.sun,
        secondUserPlanet: Planet.sun,
        orb: 2.0,
        score: 90,
        description: 'Your Suns are conjunct, creating a strong bond.',
      ),
      CompatibilityAspect(
        aspect: Aspect.trine,
        firstUserPlanet: Planet.moon,
        secondUserPlanet: Planet.moon,
        orb: 3.0,
        score: 85,
        description: 'Your Moons are trine, creating emotional harmony.',
      ),
    ];
  }
  
  /// Generate compatibility report
  Future<String> _generateCompatibilityReport(
    Chart chart1,
    Chart chart2,
    int astrologicalScore,
    int questionnaireScore,
    int overallScore,
    CompatibilityLevel overallLevel,
    List<CompatibilityCategory> categories,
    List<CompatibilityAspect> aspects,
  ) async {
    final buffer = StringBuffer();
    
    // Introduction
    buffer.writeln('# Compatibility Report');
    buffer.writeln();
    buffer.writeln('## Overall Compatibility');
    buffer.writeln();
    buffer.writeln('Your overall compatibility score is $overallScore%, which is considered ${Compatibility.getCompatibilityLevelName(overallLevel).toLowerCase()}.');
    buffer.writeln();
    buffer.writeln('This score is calculated based on two main components:');
    buffer.writeln('- Astrological Compatibility: $astrologicalScore%');
    buffer.writeln('- Questionnaire Compatibility: $questionnaireScore%');
    buffer.writeln();
    
    // Astrological compatibility
    buffer.writeln('## Astrological Compatibility');
    buffer.writeln();
    buffer.writeln('Your astrological compatibility is based on the positions of planets in your birth charts:');
    buffer.writeln();
    buffer.writeln('- ${chart1.sunSign} Sun + ${chart2.sunSign} Sun');
    buffer.writeln('- ${chart1.moonSign} Moon + ${chart2.moonSign} Moon');
    if (chart1.ascendantSign != null && chart2.ascendantSign != null) {
      buffer.writeln('- ${chart1.ascendantSign} Ascendant + ${chart2.ascendantSign} Ascendant');
    }
    buffer.writeln();
    
    // Questionnaire compatibility
    buffer.writeln('## Questionnaire Compatibility');
    buffer.writeln();
    if (questionnaireScore > 0) {
      buffer.writeln('Your questionnaire compatibility is based on your answers to questions about values, lifestyle, communication, intimacy, and future goals.');
    } else {
      buffer.writeln('You have not completed the compatibility questionnaire yet. Complete it to get a more accurate compatibility score.');
    }
    buffer.writeln();
    
    // Categories
    buffer.writeln('## Compatibility Categories');
    buffer.writeln();
    for (final category in categories) {
      buffer.writeln('### ${category.name}');
      buffer.writeln();
      buffer.writeln('Score: ${category.score}% (${Compatibility.getCompatibilityLevelName(category.level)})');
      buffer.writeln();
      buffer.writeln(category.description);
      buffer.writeln();
    }
    
    // Aspects
    buffer.writeln('## Key Aspects');
    buffer.writeln();
    for (final aspect in aspects) {
      buffer.writeln('- ${aspect.firstUserPlanet.toString().split('.').last} ${aspect.aspect.toString().split('.').last} ${aspect.secondUserPlanet.toString().split('.').last} (${aspect.score}%)');
      buffer.writeln('  ${aspect.description}');
      buffer.writeln();
    }
    
    // Conclusion
    buffer.writeln('## Conclusion');
    buffer.writeln();
    buffer.writeln(_getOverallDescription(overallLevel, chart1.sunSign, chart2.sunSign));
    buffer.writeln();
    
    return buffer.toString();
  }
  
  /// Get overall description
  String _getOverallDescription(CompatibilityLevel level, ZodiacSign sign1, ZodiacSign sign2) {
    switch (level) {
      case CompatibilityLevel.veryLow:
        return 'You may face significant challenges in this relationship. Your ${sign1.toString().split('.').last} and ${sign2.toString().split('.').last} combination requires extra effort to understand each other\'s differences.';
      case CompatibilityLevel.low:
        return 'This relationship may require work to overcome differences. Your ${sign1.toString().split('.').last} and ${sign2.toString().split('.').last} combination has some natural friction, but with understanding, you can grow together.';
      case CompatibilityLevel.moderate:
        return 'You have a balanced relationship with both strengths and challenges. Your ${sign1.toString().split('.').last} and ${sign2.toString().split('.').last} combination offers opportunities for growth and learning.';
      case CompatibilityLevel.high:
        return 'You have a strong connection with many compatible elements. Your ${sign1.toString().split('.').last} and ${sign2.toString().split('.').last} combination naturally supports understanding and harmony.';
      case CompatibilityLevel.veryHigh:
        return 'You have an exceptional connection with remarkable compatibility. Your ${sign1.toString().split('.').last} and ${sign2.toString().split('.').last} combination creates a powerful and harmonious bond.';
    }
  }
  
  /// Get emotional description
  String _getEmotionalDescription(CompatibilityLevel level, ZodiacSign sign1, ZodiacSign sign2) {
    final element1 = _chartService.getElementForSign(sign1);
    final element2 = _chartService.getElementForSign(sign2);
    
    String elementDescription = '';
    if (element1 == element2) {
      elementDescription = 'Your emotional natures are similar, both being ${element1.toString().split('.').last} signs.';
    } else {
      elementDescription = 'Your emotional natures are different, with ${sign1.toString().split('.').last} being a ${element1.toString().split('.').last} sign and ${sign2.toString().split('.').last} being a ${element2.toString().split('.').last} sign.';
    }
    
    switch (level) {
      case CompatibilityLevel.veryLow:
        return 'Your emotional compatibility is challenging. $elementDescription You may need to work hard to understand each other\'s emotional needs.';
      case CompatibilityLevel.low:
        return 'Your emotional compatibility requires effort. $elementDescription With patience, you can learn to appreciate your different emotional styles.';
      case CompatibilityLevel.moderate:
        return 'Your emotional compatibility is balanced. $elementDescription You have some natural understanding but also areas where you need to bridge gaps.';
      case CompatibilityLevel.high:
        return 'Your emotional compatibility is strong. $elementDescription You naturally understand and support each other\'s emotional needs.';
      case CompatibilityLevel.veryHigh:
        return 'Your emotional compatibility is exceptional. $elementDescription You have a deep intuitive understanding of each other\'s feelings and needs.';
    }
  }
  
  /// Get communication description
  String _getCommunicationDescription(CompatibilityLevel level, Chart chart1, Chart chart2) {
    return 'Your communication compatibility is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
  }
  
  /// Get physical description
  String _getPhysicalDescription(CompatibilityLevel level, Chart chart1, Chart chart2) {
    return 'Your physical compatibility is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
  }
  
  /// Get intellectual description
  String _getIntellectualDescription(CompatibilityLevel level, Chart chart1, Chart chart2) {
    return 'Your intellectual compatibility is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
  }
  
  /// Get spiritual description
  String _getSpiritualDescription(CompatibilityLevel level, Chart chart1, Chart chart2) {
    return 'Your spiritual compatibility is ${Compatibility.getCompatibilityLevelName(level).toLowerCase()}.';
  }
  
  /// Get aspect description
  String _getAspectDescription(Aspect aspect, Planet planet1, Planet planet2) {
    switch (aspect) {
      case Aspect.conjunction:
        return 'Your ${planet1.toString().split('.').last} and ${planet2.toString().split('.').last} are conjunct, creating a strong bond.';
      case Aspect.sextile:
        return 'Your ${planet1.toString().split('.').last} and ${planet2.toString().split('.').last} are sextile, creating opportunities for growth.';
      case Aspect.square:
        return 'Your ${planet1.toString().split('.').last} and ${planet2.toString().split('.').last} are square, creating tension and challenges.';
      case Aspect.trine:
        return 'Your ${planet1.toString().split('.').last} and ${planet2.toString().split('.').last} are trine, creating harmony and flow.';
      case Aspect.opposition:
        return 'Your ${planet1.toString().split('.').last} and ${planet2.toString().split('.').last} are opposite, creating polarity and balance.';
    }
  }
}
