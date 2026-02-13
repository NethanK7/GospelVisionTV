import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/core/theme/app_colors.dart';
import 'package:gv_tv/features/home/views/widgets/content_card.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'MOVIES & SHOWS',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('movies')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading movies',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.lightTextPrimary,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandOrange),
            );
          }

          final movies = snapshot.data!.docs;

          if (movies.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  'No movies available yet.',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            );
          }

          final featuredData = movies.first.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Movie Banner (Dynamic from first movie)
                _buildFeaturedBanner(context, featuredData),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LATEST RELEASES',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Poster Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final data = movies[index].data() as Map<String, dynamic>;
                    final title = data['title'] ?? 'Untitled';
                    final imageUrl = data['imageUrl'] ?? '';

                    return ContentCard(
                      title: title,
                      imageUrl: imageUrl,
                      onTap: () => context.push(
                        '/movie-detail',
                        extra: {
                          'title': title,
                          'imageUrl': imageUrl,
                          'description':
                              data['description'] ??
                              'No description available.',
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedBanner(BuildContext context, Map<String, dynamic> data) {
    final title = data['title'] ?? 'Untitled';
    final imageUrl = data['imageUrl'] ?? '';

    return Container(
      height: 240,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.9),
              Colors.black.withValues(alpha: 0.2),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.premiumGold.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.premiumGold.withValues(alpha: 0.5),
                ),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  color: AppColors.premiumGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push(
                '/movie-detail',
                extra: {
                  'title': title,
                  'imageUrl': imageUrl,
                  'description':
                      data['description'] ?? 'No description available.',
                },
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('WATCH NOW'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
