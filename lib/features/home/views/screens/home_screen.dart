import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/features/home/providers/home_provider.dart';
import 'package:gv_tv/core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset('assets/images/logo.png', height: 40),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).loadData(),
        child: homeState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // Hero Banner Section
                  if (homeState.trendingMovies.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _HeroBanner(item: homeState.trendingMovies.first),
                    ),

                  // Trending Movies Row
                  if (homeState.trendingMovies.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _ContentRow(
                        title: 'Trending Now',
                        items: homeState.trendingMovies,
                      ).animate().fadeIn(delay: 200.ms),
                    ),

                  // Grace & Truth Row
                  if (homeState.graceAndTruth.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _ContentRow(
                        title: 'Grace & Truth',
                        items: homeState.graceAndTruth,
                        isNews: true,
                      ).animate().fadeIn(delay: 400.ms),
                    ),

                  // Popular on Gospel Vision
                  if (homeState.trendingMovies.length > 3)
                    SliverToBoxAdapter(
                      child: _ContentRow(
                        title: 'Popular on Gospel Vision',
                        items: homeState.trendingMovies.reversed.toList(),
                      ).animate().fadeIn(delay: 600.ms),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final dynamic item;

  const _HeroBanner({required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 600,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          height: 600,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.8),
                Colors.black,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        ),

        // Content
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  item.title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
              ),

              const SizedBox(height: 16),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTag('ORIGINAL'),
                  const SizedBox(width: 8),
                  _buildTag(item.category ?? 'MOVIE'),
                ],
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Play Button
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        '/movie-detail',
                        extra: {
                          'title': item.title,
                          'imageUrl': item.imageUrl,
                          'description': 'A Gospel Vision original production.',
                        },
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text(
                      'Play',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // My List Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 24),
                    label: const Text(
                      'My List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.brandOrange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.brandOrange.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ContentRow extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final bool isNews;

  const _ContentRow({
    required this.title,
    required this.items,
    this.isNews = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _NetflixCard(item: item, isNews: isNews, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _NetflixCard extends StatelessWidget {
  final dynamic item;
  final bool isNews;
  final int index;

  const _NetflixCard({
    required this.item,
    required this.isNews,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isNews) {
          context.push('/news');
        } else {
          context.push(
            '/movie-detail',
            extra: {
              'title': item.title,
              'imageUrl': item.imageUrl,
              'description': 'A beautiful production from Gospel Vision TV.',
            },
          );
        }
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.2, end: 0),
    );
  }
}
