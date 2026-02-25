import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  Widget build(BuildContext context) {
    if (widget.featuredContent.isEmpty) return const SizedBox();

    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final double heroHeight = isDesktop
        ? MediaQuery.of(context).size.height * 0.85
        : MediaQuery.of(context).size.height * 0.7;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.featuredContent.length,
            options: CarouselOptions(
              height: heroHeight,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 8),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final content = widget.featuredContent[index];
              return _HeroSlide(content: content, isDesktop: isDesktop);
            },
          ),

          // Custom Pagination Dots
          if (widget.featuredContent.length > 1)
            Positioned(
              bottom: isDesktop ? 40 : 20,
              right: isDesktop ? 60 : 20,
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
  final bool isDesktop;

  const _HeroSlide({required this.content, required this.isDesktop});

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

        // Content Box
        Positioned(
          bottom: isDesktop ? 80 : 40,
          left: isDesktop ? 60 : 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(
                        fontSize: isDesktop ? 72 : 48,
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
              if (isDesktop)
                SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        content.description,
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
              Row(
                    children: [
                      _buildPlayButton(),
                      const SizedBox(width: 16),
                      _buildMoreInfoButton(),
                    ],
                  )
                  .animate(key: ValueKey('btns_${content.id}'))
                  .slideY(begin: 0.2, end: 0)
                  .fadeIn(duration: 800.ms, delay: 500.ms),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
        label: const Text(
          'Play',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.offWhite,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  Widget _buildMoreInfoButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.info_outline, color: AppTheme.offWhite, size: 28),
      label: const Text(
        'More Info',
        style: TextStyle(
          color: AppTheme.offWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.25),
        foregroundColor: AppTheme.offWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
    );
  }
}
