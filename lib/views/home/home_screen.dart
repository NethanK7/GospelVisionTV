import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_controller.dart';
import '../../models/movie_model.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryOrange),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: AppTheme.primaryOrange,
            child: CustomScrollView(
              slivers: [
                // Top App Bar Area (Netflix style usually has a transparent overlay or simple logo)
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    children: [
                      // Simple Text or Image logo. We'll use Text for now since we don't have the image file path yet.
                      Text(
                        'GOSPELVISION',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Hero Section
                      if (controller.featuredMovie != null)
                        _buildHeroSection(context, controller.featuredMovie!),

                      const SizedBox(height: 20),

                      // 2. Categories Horizontal scroll
                      _buildCategoriesList(context, controller.categories),

                      const SizedBox(height: 20),

                      // 3. Continue Watching
                      if (controller.continueWatching.isNotEmpty)
                        _buildHorizontalList(
                          context,
                          title: 'Continue Watching for you',
                          movies: controller.continueWatching,
                          showProgress: true,
                        ),

                      const SizedBox(height: 20),

                      // 4. Trending
                      if (controller.trendingMovies.isNotEmpty)
                        _buildHorizontalList(
                          context,
                          title: 'Trending on GospelVision',
                          movies: controller.trendingMovies,
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, MovieModel movie) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Hero Image
        Container(
          height: 400,
          width: double.infinity,
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent, Colors.black],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.0, 0.3, 1.0],
            ),
          ),
          child: Image.network(
            movie.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[900]),
          ),
        ),

        // Hero Content
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              if (movie.isBrandNew)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Netflix_2015_logo.svg/200px-Netflix_2015_logo.svg.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ), // Placeholder for "N Series" style icon
                    const SizedBox(width: 8),
                    Text(
                      'GOSPELVISION ORIGINAL',
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                movie.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.category,
                style: const TextStyle(fontSize: 14, color: AppTheme.textWhite),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconTextButton(Icons.add, 'My List', () {}),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow, color: Colors.black),
                    label: const Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  _buildIconTextButton(Icons.info_outline, 'Info', () {}),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconTextButton(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    List<CategoryModel> categories,
  ) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categories[index].name),
              selected: index == 0, // Make first selected for visual
              onSelected: (val) {},
              selectedColor: AppTheme.primaryOrange.withOpacity(0.2),
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: index == 0 ? AppTheme.primaryOrange : Colors.grey[800]!,
              ),
              labelStyle: TextStyle(
                color: index == 0 ? AppTheme.primaryOrange : Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalList(
    BuildContext context, {
    required String title,
    required List<MovieModel> movies,
    bool showProgress = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: showProgress ? 200 : 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: showProgress ? 140 : 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(movie.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              if (movie.isBrandNew)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryOrange,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'NEW',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              if (showProgress)
                                const Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 40,
                                    color: Colors.white70,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Progress Bar
                      if (showProgress) ...[
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: movie.progress,
                          color: AppTheme.primaryOrange,
                          backgroundColor: Colors.grey[800],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
