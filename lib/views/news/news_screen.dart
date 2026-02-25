import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_controller.dart';
import '../../models/content_model.dart';
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
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(scrollOffset: _scrollOffset, isDesktop: isDesktop),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).padding.top +
                      (isDesktop ? 100 : 80),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 60 : 16,
                    vertical: 12,
                  ),
                  child: const Text(
                    'New & Popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32, // Netflix style large header
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 44 : 12),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppTheme.primaryOrange,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textGrey,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Coming Soon'),
                  Tab(text: "Everyone's Watching"),
                  Tab(text: 'Top 10'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ComingSoonTab(isDesktop: isDesktop),
                  _EveryoneWatchingTab(isDesktop: isDesktop),
                  _Top10Tab(isDesktop: isDesktop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// COMING SOON TAB
// ============================================================
class _ComingSoonTab extends StatelessWidget {
  final bool isDesktop;

  const _ComingSoonTab({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final items = controller.newReleases;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ComingSoonItem(item: items[index], isDesktop: isDesktop);
      },
    );
  }
}

class _ComingSoonItem extends StatelessWidget {
  final ContentModel item;
  final bool isDesktop;

  const _ComingSoonItem({required this.item, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/detail/${item.id}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with play overlay
            Stack(
              children: [
                Container(
                  height: isDesktop ? 300 : 200,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 0),
                  decoration: BoxDecoration(
                    borderRadius: isDesktop
                        ? BorderRadius.circular(8)
                        : BorderRadius.zero,
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Volume/mute button
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volume_off,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Content info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date column
                  SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Text(
                          _getMonth(),
                          style: const TextStyle(
                            color: AppTheme.textGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _getDay(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            _actionIcon(
                              Icons.notifications_outlined,
                              'Remind Me',
                            ),
                            const SizedBox(width: 20),
                            _actionIcon(Icons.info_outline, 'Info'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: AppTheme.textGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.genres.join(' \u2022 '),
                          style: const TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  String _getMonth() {
    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN'];
    final idx = item.id.hashCode.abs() % months.length;
    return months[idx];
  }

  String _getDay() {
    return '${(item.id.hashCode.abs() % 28) + 1}';
  }

  Widget _actionIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 9),
        ),
      ],
    );
  }
}

// ============================================================
// EVERYONE'S WATCHING TAB
// ============================================================
class _EveryoneWatchingTab extends StatelessWidget {
  final bool isDesktop;

  const _EveryoneWatchingTab({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final items = controller.trending;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => context.push('/detail/${item.id}'),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  height: isDesktop ? 280 : 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: isDesktop
                        ? BorderRadius.circular(8)
                        : BorderRadius.zero,
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (item.isOriginal)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOrange,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Text(
                                  'GV ORIGINAL',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// TOP 10 TAB
// ============================================================
class _Top10Tab extends StatelessWidget {
  final bool isDesktop;

  const _Top10Tab({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final items = controller.top10;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 16,
        vertical: 8,
      ),
      itemCount: items.take(10).length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => context.push('/detail/${item.id}'),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Rank number
                SizedBox(
                  width: 40,
                  child: Text(
                    '${index + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: index < 3 ? AppTheme.primaryOrange : Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    item.imageUrl,
                    width: 100,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 100,
                      height: 56,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.genres.take(2).join(' \u2022 '),
                        style: const TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow/play
                Icon(
                  Icons.play_circle_outline,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 28,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
