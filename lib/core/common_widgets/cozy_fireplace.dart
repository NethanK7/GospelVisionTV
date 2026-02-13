import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class CozyFireplace extends StatelessWidget {
  final double height;
  final bool isLightMode;

  const CozyFireplace({super.key, this.height = 40, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          _RealisticFireGlow(height: height, isLightMode: isLightMode),
          _RealisticFireParticles(height: height, isLightMode: isLightMode),
          _FireSparks(height: height),
        ],
      ),
    );
  }
}

class _RealisticFireGlow extends StatelessWidget {
  final double height;
  final bool isLightMode;

  const _RealisticFireGlow({required this.height, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    final color = isLightMode ? Colors.orange : const Color(0xFFFF4500);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child:
          Container(
                height: height * 0.7,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 1.3),
                    radius: 1.4,
                    colors: [
                      color.withValues(alpha: 0.12),
                      color.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(duration: 4.seconds),
    );
  }
}

class _RealisticFireParticles extends StatefulWidget {
  final double height;
  final bool isLightMode;

  const _RealisticFireParticles({
    required this.height,
    required this.isLightMode,
  });

  @override
  State<_RealisticFireParticles> createState() =>
      _RealisticFireParticlesState();
}

class _RealisticFireParticlesState extends State<_RealisticFireParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FireParticle> _particles = [];
  final math.Random _random = math.Random();
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 16),
          )
          ..addListener(_updateParticles)
          ..repeat();
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      _time += 0.016;
      if (_particles.length < 100 && _random.nextDouble() < 0.8) {
        _particles.add(_FireParticle(_random));
      }

      for (int i = _particles.length - 1; i >= 0; i--) {
        _particles[i].update(_time);
        if (_particles[i].life <= 0) {
          _particles.removeAt(i);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, widget.height),
      painter: _FireParticlePainter(_particles, widget.isLightMode, _time),
    );
  }
}

class _FireParticle {
  double x;
  double y;
  final double vy;
  double size;
  double life;
  final double wavePhase;

  _FireParticle(math.Random random)
    : x = 0.35 + random.nextDouble() * 0.3,
      y = 0,
      vy = 1.2 + random.nextDouble() * 1.5,
      size = 12.0 + random.nextDouble() * 18.0,
      life = 1.0,
      wavePhase = random.nextDouble() * math.pi * 2;

  void update(double time) {
    y += vy;
    x += math.sin(time * 2 + wavePhase) * 0.0015;
    life -= 0.012;
    size *= 0.985;
  }
}

class _FireParticlePainter extends CustomPainter {
  final List<_FireParticle> particles;
  final bool isLightMode;
  final double time;

  _FireParticlePainter(this.particles, this.isLightMode, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..blendMode = BlendMode.screen;

    for (var p in particles) {
      final double progress = (1.0 - p.life).clamp(0.0, 1.0);
      final double opacity = (p.life * 0.7).clamp(0.0, 1.0);

      Color color;
      if (progress < 0.15) {
        color = Colors.white;
      } else if (progress < 0.4) {
        color = const Color(0xFFFFE082);
      } else if (progress < 0.7) {
        color = isLightMode ? Colors.orange : const Color(0xFFFF9100);
      } else {
        color = const Color(0xFFFF3D00).withValues(alpha: 0.4);
      }

      paint.color = color.withValues(alpha: opacity);
      paint.maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        (p.size * 0.6).clamp(4.0, 15.0),
      );

      final Offset center = Offset(p.x * size.width, size.height - p.y);
      final double stretch =
          1.8 + math.sin(time * 4 + p.wavePhase) * 0.3 + (progress * 1.0);

      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: p.size * 0.7,
          height: p.size * stretch,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FireParticlePainter oldDelegate) => true;
}

class _FireSparks extends StatefulWidget {
  final double height;
  const _FireSparks({required this.height});

  @override
  State<_FireSparks> createState() => _FireSparksState();
}

class _FireSparksState extends State<_FireSparks>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Spark> _sparks = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 16),
          )
          ..addListener(_updateSparks)
          ..repeat();
  }

  void _updateSparks() {
    if (!mounted) return;
    setState(() {
      if (_sparks.length < 35 && _random.nextDouble() < 0.15) {
        _sparks.add(_Spark(_random));
      }
      for (int i = _sparks.length - 1; i >= 0; i--) {
        _sparks[i].update();
        if (_sparks[i].life <= 0) _sparks.removeAt(i);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, widget.height),
      painter: _SparkPainter(_sparks),
    );
  }
}

class _Spark {
  double x;
  double y;
  final double vx;
  final double vy;
  double life;
  final double size;

  _Spark(math.Random random)
    : x = 0.2 + random.nextDouble() * 0.6,
      y = 0,
      vx = (random.nextDouble() - 0.5) * 0.008,
      vy = 3.0 + random.nextDouble() * 4.0,
      life = 1.0,
      size = 0.8 + random.nextDouble() * 1.2;

  void update() {
    x += vx;
    y += vy;
    life -= 0.01;
  }
}

class _SparkPainter extends CustomPainter {
  final List<_Spark> sparks;
  _SparkPainter(this.sparks);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var s in sparks) {
      final opacity = (s.life * 1.5).clamp(0.0, 1.0);
      paint.color = const Color(0xFFFFD54F).withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(s.x * size.width, size.height - s.y),
        s.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) => true;
}
