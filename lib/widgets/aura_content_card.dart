import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE CONTAINER
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: widget.width,
              height: widget.height,
              transform: Matrix4.translationValues(
                0.0,
                _isHovered ? -8.0 : 0.0,
                0.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered
                      ? AppTheme.primaryOrange.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.1),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                          blurRadius: 25,
                          spreadRadius: 4,
                          offset: const Offset(0, 15),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Hero(
                  tag: 'hero_${widget.content.id}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.isLarge
                            ? widget.content.imageUrl
                            : (widget.content.backdropUrl ??
                                  widget.content.imageUrl),
                        fit: BoxFit.cover,
                        memCacheWidth: widget.width.isFinite
                            ? (widget.width *
                                      MediaQuery.devicePixelRatioOf(context))
                                  .round()
                            : null,
                        placeholder: (context, url) => Container(
                          color: AppTheme.deepObsidian,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.textGrey,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.deepObsidian,
                          child: const Icon(
                            Icons.error,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ),

                      // Inner Hover Details (Frosted Glass)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _isHovered ? 1.0 : 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.9),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(12),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.content.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.content.isOriginal)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'GOSPELVISION ORIGINAL',
                                      style: TextStyle(
                                        color: AppTheme.primaryOrange
                                            .withValues(alpha: 0.9),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
