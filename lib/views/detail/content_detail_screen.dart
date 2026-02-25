import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/home_controller.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/aura_content_card.dart';

class ContentDetailScreen extends StatelessWidget {
  final String contentId;

  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context, listen: false);
    final content = controller.getContentById(contentId);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (content == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(
          child: Text(
            'Content not found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Wrap in a Scaffold with a dark background.
    // The Hero animation handles the image transition.
    return Scaffold(
      backgroundColor: AppTheme.deepObsidian,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambilight Background
          Image.network(
            content.backdropUrl ?? content.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              color: AppTheme.deepObsidian.withValues(alpha: 0.65),
            ),
          ),

          // Swipe to Dismiss Interactive Layer (Mobile)
          isDesktop
              ? _buildScrollView(content, isDesktop, controller)
              : Dismissible(
                  key: Key('dismiss_${content.id}'),
                  direction: DismissDirection.down,
                  onDismissed: (_) => context.pop(),
                  child: _buildScrollView(content, isDesktop, controller),
                ),
        ],
      ),
    );
  }

  Widget _buildScrollView(
    ContentModel content,
    bool isDesktop,
    HomeController controller,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Cinematic Backdrop with Hero
        SliverAppBar(
          expandedHeight: isDesktop ? 600 : 450,
          pinned: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: _CinematicBackdrop(content: content),
          ),
        ),

        // 2. Play Button & Metadata Section
        SliverToBoxAdapter(
          child: _ContentMetadata(content: content, isDesktop: isDesktop),
        ),

        // 3. Related Content (Lazy Grid)
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 60 : 20,
            vertical: 40,
          ),
          sliver: _RelatedContentGrid(
            controller: controller,
            currentContent: content,
            isDesktop: isDesktop,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _CinematicBackdrop extends StatelessWidget {
  final ContentModel content;

  const _CinematicBackdrop({required this.content});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Hero Image
        Hero(
          tag: 'hero_${content.id}',
          child: Image.network(
            content.backdropUrl ?? content.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: AppTheme.cardDark),
          ),
        ),

        // Deep gradient fade-up into Obsidian
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppTheme.deepObsidian,
                AppTheme.deepObsidian.withValues(alpha: 0.8),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.9],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContentMetadata extends StatelessWidget {
  final ContentModel content;
  final bool isDesktop;

  const _ContentMetadata({required this.content, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: isDesktop
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Title
          AppTheme.shimmeringText(
                Text(
                  content.title.toUpperCase(),
                  textAlign: isDesktop ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    fontSize: isDesktop ? 56 : 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),

          const SizedBox(height: 16),

          // Meta dots
          Row(
            mainAxisAlignment: isDesktop
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                '${content.matchPercentage.toInt()}% Match',
                style: const TextStyle(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Text(content.year, style: const TextStyle(color: Colors.white70)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white38),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  content.maturityRating,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              if (content.duration != null) ...[
                const SizedBox(width: 12),
                Text(
                  content.duration!,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'HD',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 24),

          // Pulsing Play Button
          Center(child: _PulsingPlayButton(isDesktop: isDesktop))
              .animate()
              .fadeIn(delay: 200.ms)
              .scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(height: 32),

          // Description & Info Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Expanded(
                flex: 6,
                child: Text(
                  content.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: isDesktop ? 18 : 15,
                    height: 1.6,
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 60),
              // Meta Details (Desktop Only row side, Mobile stacked below)
              if (isDesktop)
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailInfoRow('Cast', content.cast ?? 'Unknown'),
                      const SizedBox(height: 8),
                      _DetailInfoRow('Genres', content.genres.join(', ')),
                    ],
                  ),
                ),
            ],
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

          if (!isDesktop) ...[
            const SizedBox(height: 24),
            _DetailInfoRow('Cast', content.cast ?? 'Unknown'),
            const SizedBox(height: 8),
            _DetailInfoRow('Genres', content.genres.join(', ')),
          ],

          const SizedBox(height: 40),

          // Action Icons
          Row(
            mainAxisAlignment: isDesktop
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
            children: [
              _ActionBtn(icon: Icons.add, label: 'My List'),
              if (isDesktop) const SizedBox(width: 40),
              _ActionBtn(icon: Icons.thumb_up_alt_outlined, label: 'Rate'),
              if (isDesktop) const SizedBox(width: 40),
              _ActionBtn(icon: Icons.share, label: 'Share'),
              if (isDesktop) const SizedBox(width: 40),
              _ActionBtn(icon: Icons.download, label: 'Download'),
            ],
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}

class _PulsingPlayButton extends StatelessWidget {
  final bool isDesktop;

  const _PulsingPlayButton({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: isDesktop ? 300 : double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow, color: Colors.black, size: 32),
            label: const Text(
              'Play Now',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.03,
          duration: 2.seconds,
          curve: Curves.easeInOutSine,
        )
        .shimmer(
          duration: 3.seconds,
          delay: 2.seconds,
          color: AppTheme.primaryOrange.withValues(alpha: 0.2),
        );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  final String label;
  final String content;

  const _DetailInfoRow(this.label, this.content);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, height: 1.5),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(color: AppTheme.textDimGrey),
          ),
          TextSpan(
            text: content,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// 3. Related Content
class _RelatedContentGrid extends StatelessWidget {
  final HomeController controller;
  final ContentModel currentContent;
  final bool isDesktop;

  const _RelatedContentGrid({
    required this.controller,
    required this.currentContent,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final similar = controller.trending
        .where((c) => c.id != currentContent.id)
        .take(isDesktop ? 12 : 6)
        .toList();
    final crossAxisCount = isDesktop ? 6 : 3;

    return SliverPadding(
      padding: const EdgeInsets.only(top: 20),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Related Titles',
                style: TextStyle(
                  fontSize: isDesktop ? 24 : 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return AuraContentCard(
                content: similar[index],
                width: double.infinity,
                height: double.infinity,
              );
            }, childCount: similar.length),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}
