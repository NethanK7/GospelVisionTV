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
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppTheme.deepObsidian,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(
        scrollController: _scrollController,
        isDesktop: isDesktop,
      ),
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
                isDesktop: isDesktop,
                showProgress: true,
              ),
            _ContentRow(
              title: 'Trending Now',
              items: controller.trending,
              isDesktop: isDesktop,
            ),
            _Top10Row(items: controller.top10, isDesktop: isDesktop),
            _ContentRow(
              title: 'GospelVision Originals',
              items: controller.originals,
              isDesktop: isDesktop,
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

// CONTENT ROW (Horizontal Scroll)
// ============================================================
class _ContentRow extends StatefulWidget {
  final String title;
  final List<ContentModel> items;
  final bool isDesktop;
  final bool showProgress;
  final bool isTallPoster;

  const _ContentRow({
    required this.title,
    required this.items,
    required this.isDesktop,
    this.showProgress = false,
    this.isTallPoster = false,
  });

  @override
  State<_ContentRow> createState() => _ContentRowState();
}

class _ContentRowState extends State<_ContentRow> {
  final ScrollController _scrollController = ScrollController();
  bool _isHovered = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollBy(double offset) {
    if (!_scrollController.hasClients) return;
    final newOffset = (_scrollController.offset + offset).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.isTallPoster
        ? (widget.isDesktop ? 200.0 : 130.0)
        : (widget.isDesktop ? 240.0 : 140.0);
    final cardHeight = widget.isTallPoster ? cardWidth * 1.5 : cardWidth * 0.56;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isDesktop ? 48 : 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.isDesktop ? 20 : 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.offWhite,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: AppTheme.primaryOrange,
                size: widget.isDesktop ? 22 : 18,
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight + (widget.isDesktop ? 60 : 30),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isDesktop ? 44 : 12,
                    vertical: 6,
                  ),
                  clipBehavior: Clip.none,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AuraContentCard(
                            content: widget.items[index],
                            width: cardWidth,
                            height: cardHeight,
                            isLarge: widget.isTallPoster,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: 0.05, end: 0, duration: 400.ms);
                  },
                ),

                // Desktop Scroll Arrows (Prime Style)
                if (widget.isDesktop)
                  AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _HoverScrollButton(
                          icon: Icons.arrow_back_ios_new,
                          onPressed: () => _scrollBy(-cardWidth * 3),
                        ),
                        _HoverScrollButton(
                          icon: Icons.arrow_forward_ios,
                          onPressed: () => _scrollBy(cardWidth * 3),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HoverScrollButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HoverScrollButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: double.infinity,
      alignment: Alignment.center,
      color: Colors.black.withValues(alpha: 0.6),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}

// TOP 10 ROW
// ============================================================
class _Top10Row extends StatefulWidget {
  final List<ContentModel> items;
  final bool isDesktop;

  const _Top10Row({required this.items, required this.isDesktop});

  @override
  State<_Top10Row> createState() => _Top10RowState();
}

class _Top10RowState extends State<_Top10Row> {
  final ScrollController _scrollController = ScrollController();
  bool _isHovered = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollBy(double offset) {
    if (!_scrollController.hasClients) return;
    final newOffset = (_scrollController.offset + offset).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.isDesktop ? 160.0 : 110.0;
    final cardHeight = cardWidth * 1.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isDesktop ? 48 : 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  'TOP 10',
                  style: TextStyle(
                    fontSize: widget.isDesktop ? 12 : 10,
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
                  fontSize: widget.isDesktop ? 20 : 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.offWhite,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight + 30,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isDesktop ? 44 : 12,
                    vertical: 6,
                  ),
                  clipBehavior: Clip.none,
                  itemCount: widget.items.take(10).length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 4,
                        left: index == 0 ? 0 : 24,
                      ),
                      child:
                          _Top10Card(
                                item: widget.items[index],
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

                if (widget.isDesktop)
                  AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _HoverScrollButton(
                          icon: Icons.arrow_back_ios_new,
                          onPressed: () => _scrollBy(-cardWidth * 3),
                        ),
                        _HoverScrollButton(
                          icon: Icons.arrow_forward_ios,
                          onPressed: () => _scrollBy(cardWidth * 3),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
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
