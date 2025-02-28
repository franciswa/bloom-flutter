import 'package:flutter/material.dart';

import '../../theme/text_styles.dart';

/// Auth header widget
class AuthHeader extends StatelessWidget {
  /// Title
  final String title;

  /// Subtitle
  final String subtitle;

  /// Logo
  final Widget? logo;

  /// Creates a new [AuthHeader] instance
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo != null) ...[
          logo!,
          const SizedBox(height: 24),
        ] else ...[
          Image.asset(
            'assets/images/logo.png',
            height: 80,
            width: 80,
          ),
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: TextStyles.headline1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyles.subtitle1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
