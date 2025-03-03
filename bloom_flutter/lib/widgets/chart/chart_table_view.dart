import 'package:flutter/material.dart';

import '../../models/chart.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

/// Chart table view widget
class ChartTableView extends StatelessWidget {
  /// Chart data
  final Chart chart;

  /// Selected planet
  final Planet? selectedPlanet;

  /// On planet select callback
  final Function(Planet?)? onPlanetSelect;

  /// Creates a new [ChartTableView] instance
  const ChartTableView({
    super.key,
    required this.chart,
    this.selectedPlanet,
    this.onPlanetSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                _buildHeaderCell('SIGNS', flex: 1),
                _buildHeaderCell('PLANETS', flex: 1),
                _buildHeaderCell('HOUSES', flex: 1),
              ],
            ),
          ),

          // Table rows
          ...chart.planetaryPositions.map((position) {
            final isSelected = selectedPlanet == position.planet;
            return _buildTableRow(position, isSelected);
          }),
        ],
      ),
    );
  }

  /// Build header cell
  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyles.subtitle2.copyWith(
          color: Colors.grey[400],
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build table row
  Widget _buildTableRow(PlanetaryPosition position, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (onPlanetSelect != null) {
          onPlanetSelect!(isSelected ? null : position.planet);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[800]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Sign
            Expanded(
              child: Column(
                children: [
                  Text(
                    position.sign.toString().split('.').last.capitalize(),
                    style: TextStyles.body1.copyWith(
                      color: isSelected ? AppColors.primary : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${position.degree.toStringAsFixed(1)}°',
                    style: TextStyles.caption.copyWith(
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Planet
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getPlanetSymbol(position.planet),
                    style: TextStyle(
                      fontSize: 20,
                      color: isSelected ? AppColors.primary : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    position.planet.toString().split('.').last.toUpperCase(),
                    style: TextStyles.body1.copyWith(
                      color: isSelected ? AppColors.primary : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (position.isRetrograde)
                    Text(
                      ' ℞',
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? AppColors.primary : Colors.red,
                      ),
                    ),
                ],
              ),
            ),

            // House
            Expanded(
              child: Text(
                position.house.toString().split('.').last.capitalize(),
                style: TextStyles.body1.copyWith(
                  color: isSelected ? AppColors.primary : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
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
}

/// String extension
extension StringExtension on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
