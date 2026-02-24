import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/live_tv_controller.dart';
import '../../theme/app_theme.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  VideoPlayerController? _videoPlayerController;
  bool _isInit = false;
  bool _hasError = false;

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
      setState(() {
        _isInit = true;
      });

      _videoPlayerController!.addListener(() {
        final isPlaying = _videoPlayerController!.value.isPlaying;
        final isBuffering = _videoPlayerController!.value.isBuffering;

        liveTvController.setBuffering(isBuffering);
        if (liveTvController.isPlaying != isPlaying) {
          liveTvController.togglePlay(isPlaying);
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if we are on Web vs Mobile for specific JS interop later if needed.
    // Standard video_player package handles web HTML5 video internally.

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Live TV'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<LiveTvController>(
        builder: (context, controller, _) {
          if (_hasError) {
            return const Center(
              child: Text(
                'Error loading live stream.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!_isInit || _videoPlayerController == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryOrange),
            );
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              // Video Player
              Center(
                child: AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                ),
              ),

              // Buffering indicator
              if (controller.isBuffering)
                const CircularProgressIndicator(color: AppTheme.primaryOrange),

              // Overlay Controls
              Positioned(
                bottom: 20,
                left: 20,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'GospelVision 24/7 Broadcast',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Play/Pause Overlay (tap to toggle)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (_videoPlayerController!.value.isPlaying) {
                      _videoPlayerController!.pause();
                    } else {
                      _videoPlayerController!.play();
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child:
                        (!controller.isPlaying &&
                            !_videoPlayerController!.value.isBuffering)
                        ? const Icon(
                            Icons.play_arrow,
                            size: 80,
                            color: Colors.white70,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
