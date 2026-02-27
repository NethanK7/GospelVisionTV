import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_theme.dart';
import '../../widgets/netflix_navbar.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppTheme.deepObsidian,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(scrollController: _scrollController),
      body: Container(
        decoration: AppTheme.radialBackground,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height:
                        MediaQuery.of(context).padding.top +
                        (isTablet ? 120 : 100),
                  ),
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 60 : 16,
                    ),
                    child:
                        AppTheme.shimmeringText(
                              const Text(
                                'Christian News\n& Devotionals',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  letterSpacing: -1,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: -0.1, end: 0),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 60 : 16,
                    ),
                    child: Text(
                      'Stay updated with global ministry events, latest testimonies, and daily word.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 16,
                      ),
                    ).animate().fadeIn(duration: 800.ms),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Tab Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 44 : 12),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: AppTheme.primaryOrange,
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.textGrey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Latest News'),
                    Tab(text: 'Daily Devotionals'),
                    Tab(text: 'Ministry Events'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _NewsList(isTablet: isTablet),
                    _DevotionalsList(isTablet: isTablet),
                    _EventsList(isTablet: isTablet),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LATEST NEWS TAB
// ============================================================
class _NewsList extends StatelessWidget {
  final bool isTablet;

  const _NewsList({required this.isTablet});

  final List<Map<String, String>> mockNews = const [
    {
      'title': 'Global Worship Conference 2026 Set to Open in London',
      'category': 'GLOBAL EVENT',
      'date': 'Oct 24',
      'desc':
          'Thousands are expected to gather as GospelVision hosts its annual worship summit featuring top global leaders.',
      'image':
          'https://images.unsplash.com/photo-1438283173091-5dbf5c5a3206?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
    },
    {
      'title': 'New Documentary: The Revival in East Africa',
      'category': 'NEW RELEASE',
      'date': 'Oct 22',
      'desc':
          'An exclusive behind-the-scenes look at the sweeping revival movements currently transforming communities.',
      'image':
          'https://images.unsplash.com/photo-1544427920-c49ccbf8bfb2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
    },
    {
      'title': 'GospelVision App Reaches Top 10 in Faith Category',
      'category': 'TECH / PLATFORM',
      'date': 'Oct 15',
      'desc':
          'The newly redesigned GospelVision app has seen record downloads this week after the latest UI overhaul.',
      'image':
          'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 60 : 16,
        vertical: 10,
      ),
      itemCount: mockNews.length,
      itemBuilder: (context, index) {
        final item = mockNews[index];
        return _NewsCard(
          item: item,
          isTablet: isTablet,
        ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
      },
    );
  }
}

class _NewsCard extends StatelessWidget {
  final Map<String, String> item;
  final bool isTablet;

  const _NewsCard({required this.item, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: isTablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(context: context, width: 300, height: 200),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(
                  context: context,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(),
                ),
              ],
            ),
    );
  }

  Widget _buildImage({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    // Explicitly clamp memory cache to prevent Out Of Memory crashes
    final int cacheWidth = (width > 0 ? width : 400).toInt();

    return ClipRRect(
      borderRadius: isTablet
          ? const BorderRadius.horizontal(left: Radius.circular(16))
          : const BorderRadius.vertical(top: Radius.circular(16)),
      child: CachedNetworkImage(
        imageUrl: item['image']!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        memCacheWidth: cacheWidth,
        placeholder: (context, url) =>
            Container(color: Colors.black.withValues(alpha: 0.2)),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              item['category']!,
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              item['date']!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          item['title']!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          item['desc']!,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 15,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            'READ FULL ARTICLE →',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DAILY DEVOTIONALS TAB
// ============================================================
class _DevotionalsList extends StatelessWidget {
  final bool isTablet;

  const _DevotionalsList({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 60 : 16,
        vertical: 10,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 1,
        childAspectRatio: isTablet ? 0.9 : 1.2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E1E1E),
                    const Color(0xFF2A1A0E).withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Day ${index + 1}: Finding Peace in Chaos',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      'In today’s fast-paced world, Jesus provides a stillness that transcends all understanding. Read today’s passage in John 14...',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Read Today\'s Word',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: (100 * index).ms)
            .scaleXY(begin: 0.9, end: 1.0, curve: Curves.easeOut);
      },
    );
  }
}

// ============================================================
// MINISTRY EVENTS TAB
// ============================================================
class _EventsList extends StatelessWidget {
  final bool isTablet;

  const _EventsList({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 80,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 20),
          const Text(
            'Upcoming Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Check back soon for new global ministry schedules.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 16,
            ),
          ),
        ],
      ).animate().fadeIn(),
    );
  }
}
