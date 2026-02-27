import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LivingHero extends StatefulWidget {
  final List<ContentModel> featuredContent;

  const LivingHero({super.key, required this.featuredContent});

  @override
  State<LivingHero> createState() => _LivingHeroState();
}

class _LivingHeroState extends State<LivingHero> {
  int _currentIndex = 0;
  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.featuredContent.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentIndex + 1) % widget.featuredContent.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredContent.isEmpty) return const SizedBox();

    final bool isTablet = MediaQuery.of(context).size.width >= 800;
    final double heroHeight = isTablet
        ? MediaQuery.of(context).size.height * 0.85
        : MediaQuery.of(context).size.height * 0.7;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.featuredContent.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final content = widget.featuredContent[index];
              return _HeroSlide(content: content, isTablet: isTablet);
            },
          ),

          // Custom Pagination Dots
          if (widget.featuredContent.length > 1)
            Positioned(
              bottom: isTablet ? 40 : 20,
              right: isTablet ? 60 : 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.featuredContent.asMap().entries.map((entry) {
                  return Container(
                    width: _currentIndex == entry.key ? 24.0 : 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: _currentIndex == entry.key
                          ? AppTheme.primaryOrange
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final ContentModel content;
  final bool isTablet;

  const _HeroSlide({required this.content, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image with CachedNetworkImage and slow cinematic zoom
        CachedNetworkImage(
              imageUrl: content.backdropUrl ?? content.imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            )
            .animate(
              key: ValueKey(content.id),
            ) // Ensure it re-animates on slide change
            .fadeIn(duration: 800.ms)
            .scaleXY(
              begin: 1.0,
              end: 1.05,
              duration: 15.seconds,
              curve: Curves.easeOut,
            ),

        // Dynamic Vignette (Curved Gradient to Deep Obsidian)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppTheme.deepObsidian.withValues(alpha: 0.2),
                  AppTheme.deepObsidian.withValues(alpha: 0.8),
                  AppTheme.deepObsidian,
                ],
                stops: const [0.5, 0.75, 0.9, 1.0],
              ),
            ),
          ),
        ),

        // Content Box (Centered Astra Layout)
        Positioned(
          bottom: isTablet ? 100 : 60,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (content.isOriginal)
                Row(
                      children: [
                        const Text(
                          'GOSPELVISION',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ORIGINAL',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    )
                    .animate(key: ValueKey('orig_${content.id}'))
                    .slideY(begin: 0.5, end: 0)
                    .fadeIn(duration: 600.ms, delay: 200.ms),

              const SizedBox(height: 10),

              // ShaderMask Title inheriting Orange-Gold gradient
              ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppTheme.brandGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Text(
                      content.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 72 : 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        height: 1.1,
                      ),
                    ),
                  )
                  .animate(key: ValueKey('title_${content.id}'))
                  .slideY(begin: 0.2, end: 0)
                  .fadeIn(duration: 800.ms, delay: 300.ms),

              const SizedBox(height: 16),

              // Description (Only show on desktop, or fewer lines on mobile)
              if (isTablet)
                SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        content.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    .animate(key: ValueKey('desc_${content.id}'))
                    .fadeIn(duration: 800.ms, delay: 400.ms),

              const SizedBox(height: 24),

              // Action Buttons
              _buildRadiatingPlayButton(context, content)
                  .animate(key: ValueKey('btns_${content.id}'))
                  .slideY(begin: 0.2, end: 0)
                  .fadeIn(duration: 800.ms, delay: 500.ms),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadiatingPlayButton(BuildContext context, ContentModel content) {
    final double size = MediaQuery.of(context).size.width >= 800 ? 100 : 80;
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radiating glow pulse
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryOrange.withValues(alpha: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.8),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.3,
                duration: 1500.ms,
                curve: Curves.easeInOut,
              )
              .fade(begin: 0.4, end: 0.8, duration: 1500.ms),

          // Inner Button
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.brandGradient,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.6),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: size * 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
