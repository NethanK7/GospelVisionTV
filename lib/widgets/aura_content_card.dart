import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';

// 1x1 Transparent GIF for FadeInImage placeholder
final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x47,
  0x49,
  0x46,
  0x38,
  0x39,
  0x61,
  0x01,
  0x00,
  0x01,
  0x00,
  0x80,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0xFF,
  0xFF,
  0xFF,
  0x21,
  0xF9,
  0x04,
  0x01,
  0x00,
  0x00,
  0x00,
  0x00,
  0x2C,
  0x00,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x01,
  0x00,
  0x00,
  0x02,
  0x02,
  0x44,
  0x01,
  0x00,
  0x3B,
]);

class AuraContentCard extends StatefulWidget {
  final ContentModel content;
  final double width;
  final double height;
  final bool isLarge;

  const AuraContentCard({
    super.key,
    required this.content,
    required this.width,
    required this.height,
    this.isLarge = false,
  });

  @override
  State<AuraContentCard> createState() => _AuraContentCardState();
}

class _AuraContentCardState extends State<AuraContentCard> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (widget.width * pixelRatio).round();
    final cacheH = (widget.height * pixelRatio).round();

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        onHover: (event) =>
            setState(() => _mousePosition = event.localPosition),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: widget.height,
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.05 : 1.0,
            _isHovered ? 1.05 : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: CustomPaint(
            foregroundPainter: _GlowBorderPainter(
              isHovered: _isHovered,
              mousePosition: _mousePosition,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image Content with FadeIn (Blur-up placeholder feel) & Hero Transition
                Hero(
                  tag: 'hero_${widget.content.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: AppTheme.surfaceDark, // Base placeholder color
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.isLarge
                            ? (widget.content.backdropUrl ??
                                  widget.content.imageUrl)
                            : widget.content.imageUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 400),
                        imageCacheWidth: widget.isLarge
                            ? (cacheW * 1.5).round()
                            : cacheW,
                        imageCacheHeight: widget.isLarge
                            ? (cacheH * 1.5).round()
                            : cacheH,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(Icons.error, color: Colors.white24),
                            ),
                      ),
                    ),
                  ),
                ),

                // Inner Shine Overlay (0.5px white border at 5% opacity)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 0.5,
                    ),
                  ),
                ),

                // Subdued Gradient for text readability
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: const Alignment(
                        0,
                        0.2,
                      ), // Gradient stops near middle
                      colors: [
                        Colors.black.withValues(alpha: 0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Title overlay (always visible but shifts on hover slightly, mimicking premium UI)
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: AnimatedSlide(
                    offset: Offset(0, _isHovered ? -0.1 : 0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: Text(
                      widget.content.title,
                      style: const TextStyle(
                        color: AppTheme.offWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowBorderPainter extends CustomPainter {
  final bool isHovered;
  final Offset mousePosition;

  _GlowBorderPainter({required this.isHovered, required this.mousePosition});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isHovered) return;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );

    // Creates a radial gradient that follows the mouse
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader =
          RadialGradient(
            colors: [
              AppTheme.primaryGold.withValues(alpha: 0.8),
              AppTheme.primaryOrange.withValues(alpha: 0.2),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
            radius: 0.8, // 80% of width/height
          ).createShader(
            Rect.fromCircle(center: mousePosition, radius: size.width * 0.7),
          );

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _GlowBorderPainter oldDelegate) {
    return oldDelegate.isHovered != isHovered ||
        oldDelegate.mousePosition != mousePosition;
  }
}
