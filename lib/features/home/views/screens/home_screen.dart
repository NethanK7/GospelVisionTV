import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/features/home/providers/home_provider.dart';
import '../widgets/content_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onPressed: () => ref.read(homeProvider.notifier).loadData(),
        child: homeState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.transparent,
                    title: Text(
                      'GOSPEL VISION',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  if (homeState.trendingMovies.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _SectionHeader(title: 'TRENDING PRODUCTIONS'),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: homeState.trendingMovies.length,
                          itemBuilder: (context, index) {
                            final item = homeState.trendingMovies[index];
                            return ContentCard(
                              title: item.title,
                              imageUrl: item.imageUrl,
                              onTap: () => context.push(
                                '/movie-detail',
                                extra: {
                                  'title': item.title,
                                  'imageUrl': item.imageUrl,
                                  'description':
                                      'A beautiful production from GV TV.',
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  if (homeState.graceAndTruth.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _SectionHeader(title: 'GRACE & TRUTH'),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: homeState.graceAndTruth.length,
                          itemBuilder: (context, index) {
                            final item = homeState.graceAndTruth[index];
                            return ContentCard(
                              title: item.title,
                              imageUrl: item.imageUrl,
                              onTap: () => context.push('/news'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
