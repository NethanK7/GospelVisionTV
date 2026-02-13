import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class CozyFireplace extends StatelessWidget {
  final double height;
  final bool isLightMode;

  const CozyFireplace({
    super.key,
    required this.height,
    required this.isLightMode,
  });

  @override
  Widget build(BuildContext context) {
    if (isLightMode)
      return const SizedBox.shrink(); // Netflix style usually looks best in dark mode

    return IgnorePointer(
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.brandOrange.withValues(alpha: 0.25),
              AppColors.brandOrange.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Focused "Netflix" style floor glow
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandOrange.withValues(alpha: 0.8),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.brandOrange.withValues(alpha: 0.8),
                      AppColors.brandOrange,
                      AppColors.brandOrange.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // Subtle "Breathing" Ambient Light
            Center(
              child:
                  Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: height * 0.7,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0, 1.0),
                            radius: 1.2,
                            colors: [
                              AppColors.brandOrange.withValues(alpha: 0.18),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(duration: 3.seconds),
            ),
          ],
        ),
      ),
    );
  }
}
