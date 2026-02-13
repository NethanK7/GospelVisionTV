import 'package:flutter/material.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundBlack : Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.backgroundBlack,
                  const Color(0xFF121212),
                  const Color(0xFF000000),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8F9FA),
                  const Color(0xFFF1F3F5),
                ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: child,
    );
  }
}
