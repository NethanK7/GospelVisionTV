import 'package:flutter/material.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.backgroundBlack,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundBlack,
            Color(0xFF121212),
            Color(0xFF000000),
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: child,
    );
  }
}
