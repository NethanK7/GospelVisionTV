import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class CozyFireplace extends StatelessWidget {
  final double height;
  final bool isLightMode;

  const CozyFireplace({super.key, this.height = 40, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    final fireColor = isLightMode
        ? const Color(0xFFFFD700) // Gold
        : const Color(0xFFFF4500); // OrangeRed

    final accentColor = isLightMode
        ? Colors.white.withValues(alpha: 0.8)
        : const Color(0xFFFFD700).withValues(alpha: 0.8);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Base glow
          Container(
                height: height * 0.8,
                width: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      fireColor.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                duration: 2.seconds,
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.0),
              ),

          // Particle flames
          ...List.generate(15, (index) {
            final random = math.Random(index);
            final duration = 1.seconds + (random.nextDouble() * 1).seconds;
            final delay = (random.nextDouble() * 2).seconds;
            final size = 4.0 + random.nextDouble() * 6.0;
            final xOffset = (random.nextDouble() - 0.5) * 120.0;

            return Positioned(
              bottom: 0,
              child:
                  _FlameParticle(
                        color: index % 3 == 0 ? accentColor : fireColor,
                        size: size,
                        xOffset: xOffset,
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .moveY(
                        begin: 0,
                        end: -height * 0.8,
                        duration: duration,
                        delay: delay,
                        curve: Curves.easeOut,
                      )
                      .fadeOut(duration: duration, delay: delay)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(0.5, 0.5),
                        duration: duration,
                        delay: delay,
                      ),
            );
          }),
        ],
      ),
    );
  }
}

class _FlameParticle extends StatelessWidget {
  final Color color;
  final double size;
  final double xOffset;

  const _FlameParticle({
    required this.color,
    required this.size,
    required this.xOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(xOffset, 0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: size,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
