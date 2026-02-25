import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_controller.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';

class ContentDetailScreen extends StatelessWidget {
  final String contentId;

  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final content = controller.getContentById(contentId);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (content == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(
          child: Text('Content not found', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: isDesktop
          ? _DesktopDetailLayout(content: content, controller: controller)
          : _MobileDetailLayout(content: content, controller: controller),
    );
  }
}

// ============================================================
// MOBILE LAYOUT
// ============================================================
class _MobileDetailLayout extends StatelessWidget {
  final ContentModel content;
  final HomeController controller;

  const _MobileDetailLayout({
    required this.content,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Collapsing backdrop
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: const Color(0xFF181818),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  content.backdropUrl ?? content.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: Colors.grey[900]),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFF181818), Colors.transparent],
                      stops: [0.0, 0.6],
                    ),
                  ),
                ),
                // Play icon overlay
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content body
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  content.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),

                // Meta row
                _MetaRow(content: content),
                const SizedBox(height: 16),

                // Play button
                _PlayButton(),
                const SizedBox(height: 10),

                // Download button
                _DownloadButton(),
                const SizedBox(height: 16),

                // Description
                Text(
                  content.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Cast
                if (content.cast != null)
                  Text(
                    'Cast: ${content.cast}',
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 12,
                    ),
                  ),
                if (content.director != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Director: ${content.director}',
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                // Action buttons row
                _ActionButtonsRow(),
                const SizedBox(height: 24),

                // Tabs (More Like This / Trailers)
                _DetailTabs(controller: controller, currentContent: content),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DESKTOP LAYOUT (Modal-style like Netflix)
// ============================================================
class _DesktopDetailLayout extends StatelessWidget {
  final ContentModel content;
  final HomeController controller;

  const _DesktopDetailLayout({
    required this.content,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background dimmer
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(color: Colors.black.withValues(alpha: 0.7)),
        ),

        // Modal content
        Center(
          child: Container(
            width: 850,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.92,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero backdrop
                    SizedBox(
                      height: 480,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            content.backdropUrl ?? content.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                Container(color: Colors.grey[900]),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Color(0xFF181818), Colors.transparent],
                                stops: [0.0, 0.5],
                              ),
                            ),
                          ),

                          // Close button
                          Positioned(
                            top: 16,
                            right: 16,
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF181818),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white24,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          // Bottom content overlay
                          Positioned(
                            left: 40,
                            bottom: 40,
                            right: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (content.isOriginal)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
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
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: const Text(
                                            'GV',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'ORIGINAL',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Text(
                                  content.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    _PlayButton(),
                                    const SizedBox(width: 10),
                                    _DownloadButton(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Body
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column (60%)
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _MetaRow(content: content),
                                const SizedBox(height: 16),
                                Text(
                                  content.description,
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.85),
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          // Right column (40%)
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (content.cast != null)
                                  _DetailInfo('Cast', content.cast!),
                                if (content.director != null)
                                  _DetailInfo('Director', content.director!),
                                _DetailInfo(
                                  'Genres',
                                  content.genres.join(', '),
                                ),
                                _DetailInfo(
                                  'This show is',
                                  content.genres.join(', '),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: _ActionButtonsRow(),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: _DetailTabs(
                        controller: controller,
                        currentContent: content,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SHARED WIDGETS
// ============================================================
class _MetaRow extends StatelessWidget {
  final ContentModel content;

  const _MetaRow({required this.content});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${content.matchPercentage.toInt()}% Match',
          style: const TextStyle(
            color: AppTheme.accentGreen,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          content.year,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38, width: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            content.maturityRating,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
        if (content.duration != null)
          Text(
            content.duration!,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        if (content.seasons != null)
          Text(
            '${content.seasons} Season${content.seasons! > 1 ? 's' : ''}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30, width: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Text(
            'HD',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.play_arrow, color: Colors.black, size: 26),
        label: const Text(
          'Play',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.download, color: Colors.white, size: 22),
        label: const Text(
          'Download',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionBtn(Icons.add, 'My List'),
        _actionBtn(Icons.thumb_up_alt_outlined, 'Rate'),
        _actionBtn(Icons.share, 'Share'),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textGrey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _DetailInfo extends StatelessWidget {
  final String label;
  final String value;

  const _DetailInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: AppTheme.textDimGrey,
                fontSize: 13,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTabs extends StatefulWidget {
  final HomeController controller;
  final ContentModel currentContent;

  const _DetailTabs({
    required this.controller,
    required this.currentContent,
  });

  @override
  State<_DetailTabs> createState() => _DetailTabsState();
}

class _DetailTabsState extends State<_DetailTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab headers
        Row(
          children: [
            _tabButton('More Like This', 0),
            const SizedBox(width: 24),
            _tabButton('Trailers & More', 1),
          ],
        ),
        const SizedBox(height: 16),

        // Tab content
        if (_selectedTab == 0) _buildMoreLikeThis(isDesktop),
        if (_selectedTab == 1) _buildTrailers(),
      ],
    );
  }

  Widget _tabButton(String label, int index) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppTheme.textGrey,
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryOrange : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreLikeThis(bool isDesktop) {
    final similar = widget.controller.trending
        .where((c) => c.id != widget.currentContent.id)
        .take(6)
        .toList();
    final crossAxisCount = isDesktop ? 3 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: similar.length,
      itemBuilder: (context, index) {
        final item = similar[index];
        return GestureDetector(
          onTap: () => context.push('/detail/${item.id}'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: Colors.grey[900]),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.year,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isBrandNew)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrailers() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 48,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          const Text(
            'Trailers coming soon',
            style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
