import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/home_controller.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/netflix_navbar.dart';
import '../../widgets/aura_content_card.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.deepObsidian,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(scrollController: _scrollController),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryOrange),
            );
          }

          // Combine all content and filter by search
          final allMovies =
              [
                    ...controller.trending,
                    ...controller.newReleases,
                    ...controller.originals,
                    ...controller.kidsContent,
                  ]
                  .where((m) => m.type == ContentType.movie)
                  .toSet() // Removes duplicates
                  .toList();

          final filteredMovies = _searchQuery.isEmpty
              ? allMovies
              : allMovies
                    .where(
                      (m) =>
                          m.title.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ||
                          m.genres.any(
                            (g) => g.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ),
                          ),
                    )
                    .toList();

          // Responsive grid layout values
          final int crossAxisCount = isTablet ? 5 : 3;
          final double childAspectRatio = isTablet ? 0.65 : 0.6;

          return Container(
            decoration: AppTheme.radialBackground,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Minimal Space Top Padding
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:
                        MediaQuery.of(context).padding.top +
                        (isTablet ? 120 : 100),
                  ),
                ),

                // Modern Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 60 : 16,
                    ),
                    child:
                        Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Movies',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  height: 56,
                                  width: isTablet ? 400 : double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    onChanged: (val) =>
                                        setState(() => _searchQuery = val),
                                    decoration: InputDecoration(
                                      hintText: 'Search movies, genres...',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      suffixIcon: _searchQuery.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                _searchController.clear();
                                                setState(
                                                  () => _searchQuery = '',
                                                );
                                              },
                                            )
                                          : null,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: -0.1, end: 0),
                  ),
                ),

                // Massive Movie Grid Table
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 60 : 16,
                    vertical: 20,
                  ),
                  sliver: filteredMovies.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(
                                'No movies found for "$_searchQuery"',
                                style: const TextStyle(
                                  color: AppTheme.textGrey,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                mainAxisSpacing: isTablet ? 24 : 12,
                                crossAxisSpacing: isTablet ? 24 : 12,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final movie = filteredMovies[index];
                            final cardWidth = isTablet ? 200.0 : 130.0;
                            final cardHeight = cardWidth * 1.5;
                            return AuraContentCard(
                                  content: movie,
                                  width: cardWidth,
                                  height: cardHeight,
                                  isLarge: true,
                                )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay: (20 * (index % 12)).ms,
                                )
                                .scaleXY(
                                  begin: 0.95,
                                  end: 1.0,
                                  curve: Curves.easeOut,
                                );
                          }, childCount: filteredMovies.length),
                        ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }
}
