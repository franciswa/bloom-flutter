import 'package:flutter/material.dart';

import '../../models/chart.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import 'chart_table_view.dart';
import 'natal_chart_widget.dart';

/// Chart view type
enum ChartViewType {
  /// Wheel view
  wheel,

  /// Table view
  table,
}

/// Chart view widget
class ChartViewWidget extends StatefulWidget {
  /// Chart data
  final Chart chart;

  /// Initial view type
  final ChartViewType initialViewType;

  /// Creates a new [ChartViewWidget] instance
  const ChartViewWidget({
    super.key,
    required this.chart,
    this.initialViewType = ChartViewType.wheel,
  });

  @override
  State<ChartViewWidget> createState() => _ChartViewWidgetState();
}

class _ChartViewWidgetState extends State<ChartViewWidget>
    with SingleTickerProviderStateMixin {
  /// Current view type
  late ChartViewType _currentViewType;

  /// Selected planet
  Planet? _selectedPlanet;

  /// Animation controller
  late AnimationController _animationController;

  /// Wheel animation
  late Animation<double> _wheelAnimation;

  /// Table animation
  late Animation<double> _tableAnimation;

  @override
  void initState() {
    super.initState();
    _currentViewType = widget.initialViewType;

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize animations
    _wheelAnimation = Tween<double>(
      begin: _currentViewType == ChartViewType.wheel ? 1.0 : 0.0,
      end: _currentViewType == ChartViewType.wheel ? 1.0 : 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _tableAnimation = Tween<double>(
      begin: _currentViewType == ChartViewType.table ? 1.0 : 0.0,
      end: _currentViewType == ChartViewType.table ? 1.0 : 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Set initial animation value
    if (_currentViewType == ChartViewType.wheel) {
      _animationController.value = 0.0;
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Toggle view
  void _toggleView() {
    setState(() {
      _currentViewType = _currentViewType == ChartViewType.wheel
          ? ChartViewType.table
          : ChartViewType.wheel;

      // Update animations
      _wheelAnimation = Tween<double>(
        begin: _currentViewType == ChartViewType.wheel ? 0.0 : 1.0,
        end: _currentViewType == ChartViewType.wheel ? 1.0 : 0.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      _tableAnimation = Tween<double>(
        begin: _currentViewType == ChartViewType.table ? 0.0 : 1.0,
        end: _currentViewType == ChartViewType.table ? 1.0 : 0.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      // Run animation
      if (_currentViewType == ChartViewType.wheel) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  /// Handle planet selection
  void _handlePlanetSelect(Planet? planet) {
    setState(() {
      _selectedPlanet = planet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Birth Chart',
                style: TextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildViewToggle(),
            ],
          ),
        ),

        // Chart container
        Expanded(
          child: Stack(
            children: [
              // Wheel view
              AnimatedBuilder(
                animation: _wheelAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _wheelAnimation.value,
                    child: Transform.scale(
                      scale: 0.8 + (_wheelAnimation.value * 0.2),
                      child: child,
                    ),
                  );
                },
                child: Center(
                  child: NatalChartWidget(
                    chart: widget.chart,
                    selectedPlanet: _selectedPlanet,
                    onPlanetSelect: _handlePlanetSelect,
                  ),
                ),
              ),

              // Table view
              AnimatedBuilder(
                animation: _tableAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _tableAnimation.value,
                    child: Transform.scale(
                      scale: 0.8 + (_tableAnimation.value * 0.2),
                      child: child,
                    ),
                  );
                },
                child: ChartTableView(
                  chart: widget.chart,
                  selectedPlanet: _selectedPlanet,
                  onPlanetSelect: _handlePlanetSelect,
                ),
              ),
            ],
          ),
        ),

        // Planet details
        if (_selectedPlanet != null) _buildPlanetDetails(),
      ],
    );
  }

  /// Build view toggle
  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Table tab
          Expanded(
            child: GestureDetector(
              onTap:
                  _currentViewType == ChartViewType.wheel ? _toggleView : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentViewType == ChartViewType.table
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'TABLE',
                  style: TextStyle(
                    color: _currentViewType == ChartViewType.table
                        ? Colors.white
                        : Colors.grey[400],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Wheel tab
          Expanded(
            child: GestureDetector(
              onTap:
                  _currentViewType == ChartViewType.table ? _toggleView : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentViewType == ChartViewType.wheel
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'CIRCLE',
                  style: TextStyle(
                    color: _currentViewType == ChartViewType.wheel
                        ? Colors.white
                        : Colors.grey[400],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build planet details
  Widget _buildPlanetDetails() {
    // Find the planetary position for the selected planet
    final position = widget.chart.planetaryPositions.firstWhere(
      (p) => p.planet == _selectedPlanet,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Planet name and sign
          Row(
            children: [
              Text(
                _getPlanetSymbol(_selectedPlanet!),
                style: const TextStyle(
                  fontSize: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_selectedPlanet.toString().split('.').last} in ${position.sign.toString().split('.').last}',
                style: TextStyles.headline5.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Planet description
          Text(
            _getPlanetDescription(_selectedPlanet!, position.sign),
            style: TextStyles.body2.copyWith(
              color: Colors.grey[300],
            ),
          ),
        ],
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

  /// Get planet description
  String _getPlanetDescription(Planet planet, ZodiacSign sign) {
    switch (planet) {
      case Planet.sun:
        return 'The sun determines your ego, identity, and \'role\' in life. It\'s the core of who you are, and is the sign you\'re most likely to already know.';
      case Planet.moon:
        return 'The moon represents your emotional inner world. It determines how you process feelings and your sense of security and comfort.';
      case Planet.mercury:
        return 'Mercury governs communication, thinking patterns, rationality, and reasoning. It shows how you express yourself and process information.';
      case Planet.venus:
        return 'Venus influences how you express love and affection, what you value, and your approach to pleasure, beauty, and personal taste.';
      case Planet.mars:
        return 'Mars determines how you assert yourself, your drive, ambition, and the way you take action. It also influences your physical energy.';
      case Planet.jupiter:
        return 'Jupiter represents expansion, growth, prosperity, and good fortune. It shows where you find meaning and how you seek knowledge.';
      case Planet.saturn:
        return 'Saturn represents discipline, responsibility, limitations, and life lessons. It shows where you need to develop structure and maturity.';
      case Planet.uranus:
        return 'Uranus influences innovation, rebellion, and sudden changes. It shows where you break from tradition and express individuality.';
      case Planet.neptune:
        return 'Neptune represents dreams, intuition, spirituality, and the subconscious. It shows where you may experience confusion or inspiration.';
      case Planet.pluto:
        return 'Pluto represents transformation, power, and rebirth. It shows where you experience profound change and personal evolution.';
    }
  }
}
