import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _crossController;
  late AnimationController _textController;
  late AnimationController _glowController;
  late Animation<double> _crossScale;
  late Animation<double> _crossOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    // Cross animation
    _crossController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _crossScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _crossController, curve: Curves.easeOutBack),
    );
    _crossOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _crossController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowOpacity = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _crossController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    _glowController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      context.go('/profiles');
    }
  }

  @override
  void dispose() {
    _crossController.dispose();
    _textController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Cross + Glow
            AnimatedBuilder(
              animation: Listenable.merge([_crossController, _glowController]),
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect behind logo
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryOrange.withValues(
                              alpha: _glowOpacity.value,
                            ),
                            blurRadius: 80,
                            spreadRadius: 40,
                          ),
                        ],
                      ),
                    ),
                    // Main GV Logo Asset
                    Opacity(
                      opacity: _crossOpacity.value,
                      child: Transform.scale(
                        scale: _crossScale.value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/gv_logo.png',
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 50),

            // Animated Text (Slight subtitle)
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _textSlide.value),
                    child: Column(
                      children: [
                        Text(
                          'STREAMING WITH PURPOSE',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
