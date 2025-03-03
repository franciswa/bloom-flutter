import 'dart:math';
import 'package:flutter/material.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../../models/astrology.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

/// Zodiac selector widget
class ZodiacSelector extends StatefulWidget {
  /// On select sign callback
  final Function(ZodiacSign) onSelectSign;

  /// Creates a new [ZodiacSelector] instance
  const ZodiacSelector({
    super.key,
    required this.onSelectSign,
  });

  @override
  State<ZodiacSelector> createState() => _ZodiacSelectorState();
}

class _ZodiacSelectorState extends State<ZodiacSelector> {
  ZodiacSign _selectedSign = ZodiacSign.aries;
  final double _wheelSize = 300;
  final double _itemSize = 60;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Zodiac wheel
        WidgetCircularAnimator(
          size: _wheelSize,
          innerIconsSize: _itemSize,
          outerIconsSize: _itemSize,
          innerAnimation: Curves.easeInOutBack,
          outerAnimation: Curves.easeInOutBack,
          innerColor: AppColors.primary.withOpacity(0.1),
          outerColor: AppColors.primary.withOpacity(0.3),
          innerAnimationSeconds: 10,
          outerAnimationSeconds: 10,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: Stack(
              children: _buildZodiacSigns(),
            ),
          ),
        ),

        // Center button
        GestureDetector(
          onTap: () => widget.onSelectSign(_selectedSign),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedSign.symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select',
                  style: TextStyles.caption.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Selected sign display
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _selectedSign.name,
              style: TextStyles.subtitle1.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildZodiacSigns() {
    final List<Widget> signs = [];
    final List<ZodiacSign> zodiacSigns = ZodiacSign.values;

    for (int i = 0; i < zodiacSigns.length; i++) {
      final double angle = (2 * pi / zodiacSigns.length) * i;
      final double x = (_wheelSize / 2 - _itemSize / 2) * cos(angle);
      final double y = (_wheelSize / 2 - _itemSize / 2) * sin(angle);

      signs.add(
        Positioned(
          left: _wheelSize / 2 + x - _itemSize / 2,
          top: _wheelSize / 2 + y - _itemSize / 2,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedSign = zodiacSigns[i];
              });
            },
            child: Container(
              width: _itemSize,
              height: _itemSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedSign == zodiacSigns[i]
                    ? AppColors.primary
                    : Colors.white,
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    zodiacSigns[i].symbol,
                    style: TextStyle(
                      fontSize: 18,
                      color: _selectedSign == zodiacSigns[i]
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                  Text(
                    zodiacSigns[i].name.substring(0, 3),
                    style: TextStyle(
                      fontSize: 10,
                      color: _selectedSign == zodiacSigns[i]
                          ? Colors.white
                          : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return signs;
  }
}
