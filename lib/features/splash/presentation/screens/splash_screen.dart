import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandOrange.withValues(alpha: 0.1),
              ),
            ).animate().fadeIn(duration: 2000.ms),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.premiumGold.withValues(alpha: 0.05),
              ),
            ).animate().fadeIn(duration: 2000.ms),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cinematic Logo Entrance
                Hero(
                      tag: 'logo',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 220,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 1500.ms, curve: Curves.easeOut)
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      duration: 1500.ms,
                      curve: Curves.elasticOut,
                    )
                    .shimmer(
                      delay: 1000.ms,
                      duration: 2500.ms,
                      color: AppColors.premiumGold.withValues(alpha: 0.2),
                    ),

                const SizedBox(height: 40),

                // Progressive Loading Indicator
                SizedBox(
                  width: 140,
                  child: Column(
                    children: [
                      Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.brandOrange,
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 500.ms)
                          .scaleX(begin: 0, end: 1, duration: 2500.ms),
                      const SizedBox(height: 12),
                      const Text(
                        'POWERED BY FAITH',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ).animate().fadeIn(delay: 800.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
