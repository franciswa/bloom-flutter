import 'dart:math';
import 'package:flutter/material.dart';

import '../../models/chart.dart';
import '../../theme/app_colors.dart';

/// Natal chart widget
class NatalChartWidget extends StatelessWidget {
  /// Chart data
  final Chart chart;

  /// Width
  final double width;

  /// Height
  final double height;

  /// On planet select callback
  final Function(Planet?)? onPlanetSelect;

  /// Selected planet
  final Planet? selectedPlanet;

  /// Creates a new [NatalChartWidget] instance
  const NatalChartWidget({
    super.key,
    required this.chart,
    this.width = 300,
    this.height = 300,
    this.onPlanetSelect,
    this.selectedPlanet,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: NatalChartPainter(
          chart: chart,
          selectedPlanet: selectedPlanet,
        ),
        child: GestureDetector(
          onTapUp: (details) {
            if (onPlanetSelect != null) {
              final planet = _getPlanetAtPosition(details.localPosition);
              onPlanetSelect!(planet);
            }
          },
        ),
      ),
    );
  }

  /// Get planet at position
  Planet? _getPlanetAtPosition(Offset position) {
    // Calculate center of the chart
    final center = Offset(width / 2, height / 2);

    // Calculate radius of the chart
    final radius = min(width, height) / 2;

    // Check if tap is within the chart
    final distance = (position - center).distance;
    if (distance > radius) {
      return null;
    }

    // Find the closest planet to the tap position
    Planet? closestPlanet;
    double closestDistance = double.infinity;

    for (final planetPosition in chart.planetaryPositions) {
      final planetOffset = _getPlanetPosition(
          planetPosition.planet, planetPosition.degree, radius, center);
      final distance = (position - planetOffset).distance;

      if (distance < closestDistance && distance < 20) {
        closestDistance = distance;
        closestPlanet = planetPosition.planet;
      }
    }

    return closestPlanet;
  }

  /// Get planet position
  Offset _getPlanetPosition(
      Planet planet, double degree, double radius, Offset center) {
    // Convert degree to radians
    final radians = (degree - 90) * (pi / 180);

    // Calculate position
    final x = center.dx + radius * 0.7 * cos(radians);
    final y = center.dy + radius * 0.7 * sin(radians);

    return Offset(x, y);
  }
}

/// Natal chart painter
class NatalChartPainter extends CustomPainter {
  /// Chart data
  final Chart chart;

  /// Selected planet
  final Planet? selectedPlanet;

  /// Creates a new [NatalChartPainter] instance
  const NatalChartPainter({
    required this.chart,
    this.selectedPlanet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Draw zodiac wheel
    _drawZodiacWheel(canvas, center, radius);

    // Draw house cusps
    if (chart.houseCusps != null) {
      _drawHouseCusps(canvas, center, radius, chart.houseCusps!);
    }

    // Draw planets
    _drawPlanets(canvas, center, radius, chart.planetaryPositions);

    // Draw aspects
    if (chart.aspects != null) {
      _drawAspects(canvas, center, radius, chart.aspects!);
    }
  }

  /// Draw zodiac wheel
  void _drawZodiacWheel(Canvas canvas, Offset center, double radius) {
    // Draw outer circle
    final outerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, outerCirclePaint);

    // Draw zodiac signs
    final zodiacSignPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < 12; i++) {
      // Calculate start angle for this sign
      final startAngle = i * 30 * (pi / 180);

      // Draw arc for this sign
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, startAngle - pi / 2, pi / 6, false, zodiacSignPaint);

      // Draw sign symbol
      final sign = ZodiacSign.values[i];
      final symbolAngle = (i * 30 + 15) * (pi / 180);
      final symbolX = center.dx + (radius + 20) * cos(symbolAngle - pi / 2);
      final symbolY = center.dy + (radius + 20) * sin(symbolAngle - pi / 2);

      textPaint.text = TextSpan(
        text: _getZodiacSymbol(sign),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );

      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(symbolX - textPaint.width / 2, symbolY - textPaint.height / 2),
      );
    }
  }

  /// Draw house cusps
  void _drawHouseCusps(
      Canvas canvas, Offset center, double radius, List<HouseCusp> houseCusps) {
    final houseCuspPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final cusp in houseCusps) {
      // Calculate angle for this cusp
      final angle = cusp.degree * (pi / 180);

      // Draw line from center to edge
      final x = center.dx + radius * cos(angle - pi / 2);
      final y = center.dy + radius * sin(angle - pi / 2);

      canvas.drawLine(center, Offset(x, y), houseCuspPaint);
    }
  }

  /// Draw planets
  void _drawPlanets(Canvas canvas, Offset center, double radius,
      List<PlanetaryPosition> positions) {
    final planetPaint = Paint()..style = PaintingStyle.fill;

    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (final position in positions) {
      // Calculate angle for this planet
      final angle = position.degree * (pi / 180);

      // Calculate position
      final x = center.dx + radius * 0.7 * cos(angle - pi / 2);
      final y = center.dy + radius * 0.7 * sin(angle - pi / 2);

      // Set color based on whether this planet is selected
      if (selectedPlanet == position.planet) {
        planetPaint.color = AppColors.primary;
      } else {
        planetPaint.color = Colors.white;
      }

      // Draw planet circle
      canvas.drawCircle(Offset(x, y), 10, planetPaint);

      // Draw planet symbol
      textPaint.text = TextSpan(
        text: _getPlanetSymbol(position.planet),
        style: TextStyle(
          color:
              selectedPlanet == position.planet ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      );

      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(x - textPaint.width / 2, y - textPaint.height / 2),
      );
    }
  }

  /// Draw aspects
  void _drawAspects(
      Canvas canvas, Offset center, double radius, List<ChartAspect> aspects) {
    for (final aspect in aspects) {
      // Find positions of the two planets
      final position1 = chart.planetaryPositions.firstWhere(
        (p) => p.planet == aspect.firstPlanet,
      );

      final position2 = chart.planetaryPositions.firstWhere(
        (p) => p.planet == aspect.secondPlanet,
      );

      // Calculate angles
      final angle1 = position1.degree * (pi / 180);
      final angle2 = position2.degree * (pi / 180);

      // Calculate positions
      final x1 = center.dx + radius * 0.7 * cos(angle1 - pi / 2);
      final y1 = center.dy + radius * 0.7 * sin(angle1 - pi / 2);

      final x2 = center.dx + radius * 0.7 * cos(angle2 - pi / 2);
      final y2 = center.dy + radius * 0.7 * sin(angle2 - pi / 2);

      // Set color and style based on aspect type
      final aspectPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      switch (aspect.aspect) {
        case Aspect.conjunction:
          aspectPaint.color = Colors.green;
          aspectPaint.strokeWidth = 2;
          break;
        case Aspect.opposition:
          aspectPaint.color = Colors.red;
          aspectPaint.strokeWidth = 2;
          break;
        case Aspect.trine:
          aspectPaint.color = Colors.blue;
          aspectPaint.strokeWidth = 1.5;
          break;
        case Aspect.square:
          aspectPaint.color = Colors.orange;
          aspectPaint.strokeWidth = 1.5;
          break;
        case Aspect.sextile:
          aspectPaint.color = Colors.purple;
          aspectPaint.strokeWidth = 1;
          break;
      }

      // Draw aspect line
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), aspectPaint);
    }
  }

  /// Get zodiac symbol
  String _getZodiacSymbol(ZodiacSign sign) {
    switch (sign) {
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

  /// Get planet symbol
  String _getPlanetSymbol(Planet planet) {
    switch (planet) {
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
    }
  }

  @override
  bool shouldRepaint(covariant NatalChartPainter oldDelegate) {
    return oldDelegate.chart != chart ||
        oldDelegate.selectedPlanet != selectedPlanet;
  }
}
