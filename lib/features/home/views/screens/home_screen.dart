import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/core/theme/app_colors.dart';
import 'package:gv_tv/features/home/views/widgets/content_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Hero(
          tag: 'logo',
          child: Image.asset('assets/images/logo.png', height: 42),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.05,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.05,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: isDark ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section (Featured Original)
            _buildHeroSection(context),

            const SizedBox(height: 24),

            // Category Chips
            _buildCategoryRow(),

            const SizedBox(height: 32),

            // Continue Watching
            _buildSection(
              context,
              title: 'Continue Watching',
              children: [
                ContentCard(
                  title: 'The Chosen - S1 E1',
                  imageUrl:
                      'https://images.unsplash.com/photo-1512314889357-e157c22f938d?w=500',
                  progress: 0.7,
                  onTap: () => context.push(
                    '/movie-detail',
                    extra: {
                      'title': 'The Chosen - S1 E1',
                      'imageUrl':
                          'https://images.unsplash.com/photo-1512314889357-e157c22f938d?w=500',
                    },
                  ),
                ),
                ContentCard(
                  title: 'Worship Night 2024',
                  imageUrl:
                      'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=500',
                  progress: 0.3,
                  onTap: () => context.push(
                    '/movie-detail',
                    extra: {
                      'title': 'Worship Night 2024',
                      'imageUrl':
                          'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=500',
                    },
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 16),

            // Featured Live Now (Gradient Card)
            _buildLivePremiumCard(context),

            const SizedBox(height: 32),

            // Trending Rows
            _buildSection(
              context,
              title: 'Trending Movies',
              children: List.generate(
                5,
                (i) => ContentCard(
                  title: 'Production ${i + 1}',
                  imageUrl:
                      'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?w=500&q=$i',
                  onTap: () => context.push(
                    '/movie-detail',
                    extra: {
                      'title': 'Production ${i + 1}',
                      'imageUrl':
                          'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?w=500&q=$i',
                    },
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 32),

            _buildSection(
              context,
              title: 'Grace & Truth Series',
              children: List.generate(
                5,
                (i) => ContentCard(
                  title: 'Episode ${i + 1}',
                  imageUrl:
                      'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?w=500&q=$i',
                  onTap: () => context.push(
                    '/movie-detail',
                    extra: {
                      'title': 'Episode ${i + 1}',
                      'imageUrl':
                          'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?w=500&q=$i',
                    },
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),

            const SizedBox(height: 120), // Added bottom space for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 600,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=2070', // More cinematic lens
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.95),
                Colors.black.withValues(alpha: 0.7),
                Colors.black.withValues(alpha: 0.2),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.brandOrange.withValues(alpha: 0.4),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      color: AppColors.brandOrange,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'ORIGINAL PROJECT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideX(begin: -0.2, end: 0),
              const SizedBox(height: 16),
              const Text(
                'THE UNKNOWN\nJOURNEY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  height: 0.9,
                  letterSpacing: -1.5,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              const Text(
                'A visually stunning exploration of faith in the modern digital age.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.3,
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push(
                        '/movie-detail',
                        extra: {
                          'title': 'THE UNKNOWN JOURNEY',
                          'imageUrl':
                              'https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=2070',
                        },
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 28),
                      label: const Text(
                        'PLAY NOW',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 1.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
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
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow() {
    final categories = [
      'All Content',
      'Sermons',
      'Movies',
      'Kids',
      'Live TV',
      'Worship',
    ];
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.brandOrange
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5, end: 0);
  }

  Widget _buildLivePremiumCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/live'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.brandOrange,
              AppColors.brandOrange.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandOrange.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.live_tv_rounded,
                size: 160,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .fade(duration: 800.ms),
                            const SizedBox(width: 8),
                            const Text(
                              'LIVE NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Gospel Vision Main',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'Morning Glory Service',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/live'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.brandOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'WATCH',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.9,
                  ),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.2,
                ),
                size: 14,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: children.length,
            itemBuilder: (context, index) {
              return children[index]
                  .animate()
                  .fadeIn(delay: (index * 80).ms, duration: 500.ms)
                  .slideX(begin: 0.1, end: 0);
            },
          ),
        ),
      ],
    );
  }
}
