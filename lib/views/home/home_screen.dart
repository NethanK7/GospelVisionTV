import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/home_controller.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/netflix_navbar.dart';
import '../../widgets/living_hero.dart';
import '../../widgets/aura_content_card.dart';
import '../../widgets/live_tv_ribbon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepObsidian,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(scrollController: _scrollController),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return _buildLoadingShimmer();
          }

          // Generate the rows to stagger animate them via Slivers
          final List<Widget> contentRows = [
            if (controller.continueWatching.isNotEmpty)
              _ContentRow(
                title: 'Continue Watching',
                items: controller.continueWatching,
                showProgress: true,
              ),
            _ContentRow(title: 'Trending Now', items: controller.trending),
            _Top10Row(items: controller.top10),
            _ContentRow(
              title: 'GospelVision Originals',
              items: controller.originals,
              isTallPoster: true,
            ),
            const SizedBox(height: 100),
          ];

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: AppTheme.primaryOrange,
            backgroundColor: AppTheme.deepObsidian,
            child: Container(
              decoration: AppTheme.radialBackground,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // LIVING HERO / CAROUSEL
                  SliverToBoxAdapter(
                    child: controller.featuredContent.isNotEmpty
                        ? LivingHero(
                            featuredContent: controller.featuredContent,
                          )
                        : const SizedBox(),
                  ),

                  // LIVE TV RIBBON GATEWAY
                  const SliverToBoxAdapter(child: LiveTvRibbon()),

                  // CONTENT ROWS (Staggered Entry via builder)
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return contentRows[index]
                            .animate()
                            .fadeIn(duration: 600.ms, delay: (50 * index).ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuart,
                              delay: (50 * index).ms,
                            );
                      }, childCount: contentRows.length),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryOrange),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentRow extends StatelessWidget {
  final String title;
  final List<ContentModel> items;
  final bool showProgress;
  final bool isTallPoster;

  const _ContentRow({
    required this.title,
    required this.items,
    this.showProgress = false,
    this.isTallPoster = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;

        final cardWidth = isTallPoster
            ? (isTablet ? 180.0 : 130.0)
            : (isTablet ? 260.0 : 140.0);
        final cardHeight = isTallPoster ? cardWidth * 1.5 : cardWidth * 0.56;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32 : 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.offWhite,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.primaryOrange,
                    size: isTablet ? 24 : 18,
                  ),
                ],
              ),
            ),
            SizedBox(
              height:
                  cardHeight +
                  (isTablet
                      ? 60
                      : 40), // Extra space for title text below poster
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 28 : 12,
                  vertical: 6,
                ),
                clipBehavior: Clip.none,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AuraContentCard(
                          content: items[index],
                          width: cardWidth,
                          height: cardHeight,
                          isLarge: isTallPoster,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: 0.05, end: 0, duration: 400.ms);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// Deleted _HoverScrollButton

// TOP 10 ROW
// ============================================================
class _Top10Row extends StatelessWidget {
  final List<ContentModel> items;

  const _Top10Row({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        final cardWidth = isTablet ? 140.0 : 110.0;
        final cardHeight = cardWidth * 1.5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32 : 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.brandGradient,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'TOP 10',
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'in Your Country Today',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.offWhite,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: cardHeight + 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 28 : 12,
                  vertical: 6,
                ),
                clipBehavior: Clip.none,
                itemCount: items.take(10).length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 4,
                      left: index == 0 ? 0 : 24,
                    ),
                    child:
                        _Top10Card(
                              item: items[index],
                              rank: index + 1,
                              width: cardWidth,
                              height: cardHeight,
                            )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.05, end: 0, duration: 400.ms),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Top10Card extends StatelessWidget {
  final ContentModel item;
  final int rank;
  final double width;
  final double height;

  const _Top10Card({
    required this.item,
    required this.rank,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/detail/${item.id}'),
      child: SizedBox(
        width: width + 40,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Big number
            Positioned(
              left: -4,
              bottom: 0,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: height * 0.85,
                  fontWeight: FontWeight.w900,
                  color: Colors.transparent,
                  height: 0.8,
                  shadows: null,
                  decorationColor: Colors.transparent,
                ),
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
            ),
            // Number stroke text
            Positioned(
              left: -4,
              bottom: 0,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: height * 0.85,
                  fontWeight: FontWeight.w900,
                  height: 0.8,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.white.withValues(alpha: 0.3),
                ),
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
            ),
            // Poster
            Positioned(
              right: 0,
              top: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                  memCacheWidth: width.isFinite
                      ? (width * MediaQuery.devicePixelRatioOf(context)).round()
                      : null,
                  placeholder: (context, url) =>
                      Container(color: AppTheme.surfaceDark),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
