import 'package:flutter/material.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool showGradient;

  const GradientBackground({
    super.key,
    required this.child,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> darkColors = [
      Colors.black,
      Colors.black87,
      AppColors.brandOrange.withValues(alpha: 0.08),
    ];

    final List<Color> lightColors = [
      Colors.white,
      const Color(0xFFFDFCFB),
      AppColors.premiumGold.withValues(alpha: 0.08),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark ? darkColors : lightColors,
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}
