import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/core/theme/app_colors.dart';
import 'package:gv_tv/core/common_widgets/gradient_background.dart';

class MovieDetailScreen extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final String? description;

  const MovieDetailScreen({
    super.key,
    this.title,
    this.imageUrl,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final displayedTitle = title ?? 'The Unknown Journey';
    final displayedImage =
        imageUrl ??
        'https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=2070';
    final displayedDesc =
        description ??
        'A visually stunning exploration of faith in the modern digital age. Experience the intersection of spirituality and technology in this groundbreaking cinematic production.';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 450,
              pinned: true,
              stretch: true,
              backgroundColor: isDark ? Colors.black : Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(displayedImage, fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent],
                          stops: [0.0, 0.5],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandOrange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.brandOrange.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: const Text(
                            '4K ULTRA HD',
                            style: TextStyle(
                              color: AppColors.brandOrange,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '2024 • 2h 15m',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : AppColors.lightTextSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 20),
                    Text(
                          displayedTitle,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                            ),
                            label: const Text('PLAY NOW'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 32),
                    Text(
                      'STORYLINE',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 12),
                    Text(
                      displayedDesc,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : AppColors.lightTextSecondary,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 120), // Bottom space for nav bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
