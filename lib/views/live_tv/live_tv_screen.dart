import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/live_tv_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/netflix_navbar.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  VideoPlayerController? _videoPlayerController;
  final ScrollController _scrollController = ScrollController();
  bool _isInit = false;
  bool _hasError = false;
  bool _showControls = true;
  int _selectedChannel = 0;

  final List<Map<String, dynamic>> _channels = [
    {
      'name': 'GospelVision Main',
      'description': '24/7 Christian Programming',
      'icon': Icons.church,
      'color': AppTheme.primaryOrange,
    },
    {
      'name': 'Worship Channel',
      'description': 'Non-stop praise & worship',
      'icon': Icons.music_note,
      'color': const Color(0xFF9C27B0),
    },
    {
      'name': 'Kids Faith TV',
      'description': 'Safe content for kids',
      'icon': Icons.child_care,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Sermon Network',
      'description': 'World-class preaching',
      'icon': Icons.menu_book,
      'color': const Color(0xFF2196F3),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final liveTvController = Provider.of<LiveTvController>(
      context,
      listen: false,
    );
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(liveTvController.streamUrl),
      );
      await _videoPlayerController!.initialize();
      _videoPlayerController!.play();
      setState(() => _isInit = true);

      _videoPlayerController!.addListener(() {
        final isPlaying = _videoPlayerController!.value.isPlaying;
        final isBuffering = _videoPlayerController!.value.isBuffering;
        liveTvController.setBuffering(isBuffering);
        if (liveTvController.isPlaying != isPlaying) {
          liveTvController.togglePlay(isPlaying);
        }
      });
    } catch (e) {
      setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(
        scrollController: _scrollController,
        isDesktop: isDesktop,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(
              height:
                  MediaQuery.of(context).padding.top + (isDesktop ? 100 : 80),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.live_tv,
                    color: AppTheme.primaryOrange,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Live TV',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  // Live indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Video Player
            SizedBox(
              height: isDesktop ? 500 : 250,
              child: Consumer<LiveTvController>(
                builder: (context, controller, _) {
                  return GestureDetector(
                    onTap: () => setState(() => _showControls = !_showControls),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 60 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_hasError)
                            _buildErrorState()
                          else if (!_isInit)
                            _buildLoadingState()
                          else
                            Center(
                              child: AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              ),
                            ),

                          // Buffering
                          if (_isInit && controller.isBuffering)
                            const CircularProgressIndicator(
                              color: AppTheme.primaryOrange,
                              strokeWidth: 2,
                            ),

                          // Controls overlay
                          if (_showControls && _isInit)
                            _buildControlsOverlay(controller),

                          // Channel info overlay (bottom)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentRed,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _channels[_selectedChannel]['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.hd,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.fullscreen,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Channel Guide
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 16),
              child: Row(
                children: [
                  const Text(
                    'Channels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Program Guide',
                    style: TextStyle(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.primaryOrange.withValues(alpha: 0.8),
                    size: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Channel list
            SizedBox(
              height: 400,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 56 : 12),
                itemCount: _channels.length,
                itemBuilder: (context, index) {
                  final channel = _channels[index];
                  final isSelected = _selectedChannel == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _selectedChannel = index),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (channel['color'] as Color).withValues(
                                    alpha: 0.15,
                                  )
                                : const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? (channel['color'] as Color).withValues(
                                      alpha: 0.4,
                                    )
                                  : Colors.white.withValues(alpha: 0.05),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: (channel['color'] as Color).withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  channel['icon'] as IconData,
                                  color: channel['color'] as Color,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      channel['name'] as String,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      channel['description'] as String,
                                      style: const TextStyle(
                                        color: AppTheme.textGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentRed,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text(
                                    'WATCHING',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              else
                                Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white.withValues(alpha: 0.3),
                                  size: 26,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          const Text(
            'Unable to load live stream',
            style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isInit = false;
              });
              _initializePlayer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: AppTheme.primaryOrange,
          strokeWidth: 2,
        ),
        const SizedBox(height: 12),
        Text(
          'Connecting to live stream...',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildControlsOverlay(LiveTvController controller) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _showControls ? 1.0 : 0.0,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Center(
          child: IconButton(
            onPressed: () {
              if (_videoPlayerController!.value.isPlaying) {
                _videoPlayerController!.pause();
              } else {
                _videoPlayerController!.play();
              }
            },
            icon: Icon(
              controller.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}
