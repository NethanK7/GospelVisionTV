import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_controller.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/netflix_navbar.dart';

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
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: Colors.black,
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

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: AppTheme.primaryOrange,
            backgroundColor: Colors.black,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HERO CAROUSEL
                  _HeroCarousel(
                    items: controller.featuredContent,
                    isDesktop: isDesktop,
                  ),

                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Continue Watching
                        if (controller.continueWatching.isNotEmpty)
                          _ContentRow(
                            title: 'Continue Watching',
                            items: controller.continueWatching,
                            isDesktop: isDesktop,
                            showProgress: true,
                          ),

                        // Trending Now
                        _ContentRow(
                          title: 'Trending Now',
                          items: controller.trending,
                          isDesktop: isDesktop,
                        ),

                        // TOP 10
                        _Top10Row(
                          items: controller.top10,
                          isDesktop: isDesktop,
                        ),

                        // GospelVision Originals (tall posters)
                        _ContentRow(
                          title: 'GospelVision Originals',
                          items: controller.originals,
                          isDesktop: isDesktop,
                          isTallPoster: true,
                        ),

                        // Sermons & Preaching
                        _ContentRow(
                          title: 'Sermons & Preaching',
                          items: controller.sermons,
                          isDesktop: isDesktop,
                        ),

                        // Worship & Music
                        _ContentRow(
                          title: 'Worship & Music',
                          items: controller.worship,
                          isDesktop: isDesktop,
                        ),

                        // Bible Documentaries
                        _ContentRow(
                          title: 'Bible Documentaries',
                          items: controller.documentaries,
                          isDesktop: isDesktop,
                        ),

                        // New Releases
                        _ContentRow(
                          title: 'New Releases',
                          items: controller.newReleases,
                          isDesktop: isDesktop,
                        ),

                        // Kids & Family
                        _ContentRow(
                          title: 'Kids & Family',
                          items: controller.kidsContent,
                          isDesktop: isDesktop,
                        ),

                        const SizedBox(height: 100),
                      ],
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

// ============================================================
// NAVBAR
// ============================================================
class _GospelNavbar extends StatelessWidget implements PreferredSizeWidget {
  final double scrollOffset;
  final bool isDesktop;

  const _GospelNavbar({required this.scrollOffset, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final double bgOpacity = (scrollOffset / 100).clamp(0.0, 1.0);

    return Container(
      color: Colors.black.withValues(alpha: bgOpacity),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 16,
      ).copyWith(top: MediaQuery.of(context).padding.top + 8, bottom: 8),
      child: Row(
        children: [
          // Logo
          const Text(
            'G',
            style: TextStyle(
              color: AppTheme.primaryOrange,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (isDesktop) ...[
            const Text(
              'OSPELVISION',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 40),
            _navLink('Home', true),
            _navLink('TV Shows', false),
            _navLink('Movies', false),
            _navLink('New & Popular', false),
            _navLink('My List', false),
          ],
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.cast_outlined, size: 22),
            color: Colors.white,
            onPressed: () {},
          ),
          if (isDesktop)
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 22),
              color: Colors.white,
              onPressed: () {},
            ),
          const SizedBox(width: 4),
          // Profile avatar
          GestureDetector(
            onTap: () => context.go('/profiles'),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryOrange, Color(0xFFE85D04)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
          if (isDesktop)
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _navLink(String title, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : Colors.white70,
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

// ============================================================
// HERO CAROUSEL
// ============================================================
class _HeroCarousel extends StatefulWidget {
  final List<ContentModel> items;
  final bool isDesktop;

  const _HeroCarousel({required this.items, required this.isDesktop});

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % widget.items.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heroHeight = widget.isDesktop
        ? size.height * 0.9
        : size.height * 0.62;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return _HeroSlide(item: item, isDesktop: widget.isDesktop);
            },
          ),

          // Page indicator dots
          Positioned(
            bottom: widget.isDesktop ? 140 : 70,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 3,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppTheme.primaryOrange
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final ContentModel item;
  final bool isDesktop;

  const _HeroSlide({required this.item, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.network(
          item.backdropUrl ?? item.imageUrl,
          fit: BoxFit.cover,
          alignment: isDesktop ? Alignment.centerRight : Alignment.topCenter,
          errorBuilder: (_, _, _) => Container(color: Colors.grey[900]),
        ),

        // Bottom gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black, Colors.transparent],
              stops: [0.0, 0.5],
            ),
          ),
        ),

        // Left gradient (desktop)
        if (isDesktop)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.85),
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.35, 0.7],
              ),
            ),
          ),

        // Content
        Positioned(
          left: isDesktop ? 48 : 20,
          bottom: isDesktop ? 170 : 90,
          width: isDesktop ? screenWidth * 0.4 : screenWidth - 40,
          child: Column(
            crossAxisAlignment: isDesktop
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // Original badge
              if (item.isOriginal)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          'GV',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'O R I G I N A L',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),

              // Title
              Text(
                item.title.toUpperCase(),
                textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                style: TextStyle(
                  fontSize: isDesktop ? 56 : 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                  letterSpacing: isDesktop ? 2 : 1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 15,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Genre tags
              Row(
                mainAxisAlignment: isDesktop
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: item.genres.take(3).map((genre) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        genre,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (genre != item.genres.take(3).last)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Description (desktop only)
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    item.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
                  ),
                ),

              // Buttons
              Row(
                mainAxisAlignment: isDesktop
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  // Play button
                  _HeroButton(
                    icon: Icons.play_arrow,
                    label: 'Play',
                    isPrimary: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  // More Info
                  _HeroButton(
                    icon: Icons.info_outline,
                    label: isDesktop ? 'More Info' : 'Info',
                    isPrimary: false,
                    onTap: () => context.push('/detail/${item.id}'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Maturity rating (desktop)
        if (isDesktop)
          Positioned(
            right: 0,
            bottom: 200,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                border: const Border(
                  left: BorderSide(color: Colors.white, width: 3),
                ),
              ),
              child: Text(
                item.maturityRating,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _HeroButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isPrimary
                ? Colors.white
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.black : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.black : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
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
// CONTENT ROW (Horizontal Scroll)
// ============================================================
class _ContentRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final cardWidth = isTallPoster
        ? (isDesktop ? 200.0 : 130.0)
        : (isDesktop ? 240.0 : 140.0);
    final cardHeight = isTallPoster ? cardWidth * 1.5 : cardWidth * 0.56;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE5E5E5),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: AppTheme.primaryOrange,
                size: isDesktop ? 22 : 18,
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight + (isDesktop ? 60 : 20),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 44 : 12,
              vertical: 6,
            ),
            clipBehavior: Clip.none,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _ContentCard(
                  item: items[index],
                  width: cardWidth,
                  height: cardHeight,
                  showProgress: showProgress,
                  isTall: isTallPoster,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CONTENT CARD WITH HOVER
// ============================================================
class _ContentCard extends StatefulWidget {
  final ContentModel item;
  final double width;
  final double height;
  final bool showProgress;
  final bool isTall;

  const _ContentCard({
    required this.item,
    required this.width,
    required this.height,
    this.showProgress = false,
    this.isTall = false,
  });

  @override
  State<_ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<_ContentCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.push('/detail/${widget.item.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          constraints: BoxConstraints(
            maxWidth: widget.width * (_hovered && isDesktop ? 1.35 : 1.0),
          ),
          margin: EdgeInsets.only(
            bottom: _hovered && isDesktop ? 20 : 0,
            top: _hovered && isDesktop ? 0 : 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppTheme.cardDark,
            boxShadow: _hovered && isDesktop
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.9),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
                Container(
                  width: widget.width * (_hovered && isDesktop ? 1.35 : 1.0),
                  height: widget.height * (_hovered && isDesktop ? 1.05 : 1.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gradient overlay
                      if (widget.isTall)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 80,
                          child: Container(
                            decoration: AppTheme.cardGradient as Decoration,
                          ),
                        ),
                      // NEW badge
                      if (widget.item.isBrandNew && !_hovered)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      // Original badge
                      if (widget.item.isOriginal && widget.isTall)
                        Positioned(
                          bottom: 8,
                          left: 8,
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
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Progress bar
                if (widget.showProgress)
                  LinearProgressIndicator(
                    value: widget.item.progress,
                    minHeight: 3,
                    backgroundColor: Colors.grey[800],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryOrange,
                    ),
                  ),

                // Hover expanded details (desktop only)
                if (isDesktop)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: _hovered
                        ? Container(
                            padding: const EdgeInsets.all(14),
                            color: AppTheme.cardDark,
                            width: widget.width * 1.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Action buttons
                                Row(
                                  children: [
                                    _circleBtn(
                                      Icons.play_arrow,
                                      Colors.white,
                                      Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    _circleBtn(
                                      Icons.add,
                                      Colors.transparent,
                                      Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    _circleBtn(
                                      Icons.thumb_up_alt_outlined,
                                      Colors.transparent,
                                      Colors.white,
                                    ),
                                    const Spacer(),
                                    _circleBtn(
                                      Icons.keyboard_arrow_down,
                                      Colors.transparent,
                                      Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Meta info
                                Row(
                                  children: [
                                    Text(
                                      '${widget.item.matchPercentage.toInt()}% Match',
                                      style: const TextStyle(
                                        color: AppTheme.accentGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white54,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        widget.item.maturityRating,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.item.duration ??
                                          (widget.item.seasons != null
                                              ? '${widget.item.seasons} Seasons'
                                              : ''),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.item.genres.join(' \u2022 '),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(width: double.infinity, height: 0),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: bg == Colors.transparent
            ? Border.all(color: Colors.white38, width: 1.5)
            : null,
      ),
      child: Icon(icon, color: iconColor, size: 18),
    );
  }
}

// ============================================================
// TOP 10 ROW
// ============================================================
class _Top10Row extends StatelessWidget {
  final List<ContentModel> items;
  final bool isDesktop;

  const _Top10Row({required this.items, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final cardWidth = isDesktop ? 160.0 : 110.0;
    final cardHeight = cardWidth * 1.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentRed,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  'TOP 10',
                  style: TextStyle(
                    fontSize: isDesktop ? 12 : 10,
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
                  fontSize: isDesktop ? 20 : 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE5E5E5),
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
              horizontal: isDesktop ? 44 : 12,
              vertical: 6,
            ),
            clipBehavior: Clip.none,
            itemCount: items.take(10).length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 4, left: index == 0 ? 0 : 24),
                child: _Top10Card(
                  item: items[index],
                  rank: index + 1,
                  width: cardWidth,
                  height: cardHeight,
                ),
              );
            },
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
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
