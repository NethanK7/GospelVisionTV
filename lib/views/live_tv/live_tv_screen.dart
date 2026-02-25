import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      if (!mounted) return;
      setState(() => _isInit = true);

      _videoPlayerController!.addListener(() {
        if (!mounted || _videoPlayerController == null) return;
        final isPlaying = _videoPlayerController!.value.isPlaying;
        final isBuffering = _videoPlayerController!.value.isBuffering;
        liveTvController.setBuffering(isBuffering);
        if (liveTvController.isPlaying != isPlaying) {
          liveTvController.togglePlay(isPlaying);
        }
      });
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
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
      backgroundColor: AppTheme.deepObsidian,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(
        scrollController: _scrollController,
        isDesktop: isDesktop,
      ),
      body: Container(
        decoration: AppTheme.radialBackground,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).padding.top + (isDesktop ? 100 : 80),
              ),

              // Video Player Header Section
              Center(
                    child: Container(
                      width: isDesktop ? 1200 : double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 60 : 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryOrange.withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 40,
                            spreadRadius: -10,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(color: const Color(0xFF030303)),

                              if (_hasError)
                                _buildErrorState()
                              else if (!_isInit)
                                _buildLoadingState()
                              else
                                VideoPlayer(_videoPlayerController!),

                              // Subtle interior shadow
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.6),
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.3),
                                    ],
                                    stops: const [0.0, 0.4, 1.0],
                                  ),
                                ),
                              ),

                              // Buffering Indicator
                              Consumer<LiveTvController>(
                                builder: (context, controller, _) {
                                  if (_isInit && controller.isBuffering) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppTheme.primaryOrange,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),

                              // Glassmorphic Custom Player Controls
                              if (_isInit)
                                Consumer<LiveTvController>(
                                  builder: (context, controller, child) {
                                    return MouseRegion(
                                      onEnter: (_) =>
                                          setState(() => _showControls = true),
                                      onExit: (_) =>
                                          setState(() => _showControls = false),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(
                                            () =>
                                                _showControls = !_showControls,
                                          );
                                        },
                                        child: AnimatedOpacity(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          opacity:
                                              (_showControls ||
                                                  !controller.isPlaying)
                                              ? 1.0
                                              : 0.0,
                                          child: Container(
                                            color: Colors.black.withValues(
                                              alpha: (!controller.isPlaying)
                                                  ? 0.3
                                                  : 0.05,
                                            ),
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (_videoPlayerController!
                                                      .value
                                                      .isPlaying) {
                                                    _videoPlayerController!
                                                        .pause();
                                                  } else {
                                                    _videoPlayerController!
                                                        .play();
                                                  }
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                      sigmaX: 12,
                                                      sigmaY: 12,
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            24,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.1,
                                                            ),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        controller.isPlaying
                                                            ? Icons
                                                                  .pause_rounded
                                                            : Icons
                                                                  .play_arrow_rounded,
                                                        color: Colors.white,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              // Premium "LIVE" Badge overlay
                              Positioned(
                                top: 24,
                                left: 24,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentRed.withValues(
                                      alpha: 0.9,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentRed.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
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
                                          )
                                          .animate(
                                            onPlay: (controller) =>
                                                controller.repeat(),
                                          )
                                          .fade(
                                            duration: 1.seconds,
                                            curve: Curves.easeInOut,
                                          ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'LIVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuart),

              const SizedBox(height: 48),

              // Elegant Channel Information Section
              Center(
                    child: Container(
                      width: isDesktop ? 1200 : double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 60 : 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTheme.shimmeringText(
                            const Text(
                              'Gospel Vision Main',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Join us for 24/7 continuous world-class Christian programming. Experience powerful sermons, uplifting worship, and life-changing testimonies broadcasting globally in high definition.',
                            style: TextStyle(
                              color: AppTheme.textGrey.withValues(alpha: 0.8),
                              fontSize: 18,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Aesthetic "Now Playing" Banner
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.church_rounded,
                                    color: AppTheme.primaryOrange,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'NOW PLAYING',
                                        style: TextStyle(
                                          color: AppTheme.primaryOrange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Global Worship Experience',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Join millions around the world in continuous praise and worship.',
                                        style: TextStyle(
                                          color: AppTheme.textGrey.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 14,
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
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 200.ms)
                  .slideY(begin: 0.05, end: 0, curve: Curves.easeOutQuart),

              const SizedBox(height: 120),
            ],
          ),
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
            Icons.wifi_tethering_error_rounded,
            size: 48,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Broadcast Interrupted',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unable to connect to the live stream connection.',
            style: TextStyle(
              color: AppTheme.textGrey.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isInit = false;
              });
              _initializePlayer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Retry Connection',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
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
        const SizedBox(height: 24),
        Text(
              'CONNECTING TO BROADCAST',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(duration: 1.seconds, curve: Curves.easeInOut),
      ],
    );
  }
}
