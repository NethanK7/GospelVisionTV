import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool isLive;

  const VideoPlayerWidget({super.key, required this.url, this.isLive = false});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _disposeControllers();
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    if (!mounted) return;

    setState(() {
      _isInitializing = true;
      _hasError = false;
    });

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );
      _videoPlayerController = controller;

      // Use a timeout or catch error explicitly
      await controller.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Initialization Timed Out');
        },
      );

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: !widget.isLive,
        isLive: widget.isLive,
        aspectRatio: 16 / 9,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.brandOrange,
          handleColor: AppColors.brandOrange,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white.withValues(alpha: 0.3),
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.brandOrange),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return _buildErrorState('Playback Error: $errorMessage');
        },
      );

      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      debugPrint('Video Player Error: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _hasError = true;
        });
      }
    }
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  Widget _buildErrorState(String message) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white38, size: 48),
          const SizedBox(height: 16),
          Text(
            'Content Unavailable',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'We had trouble loading this stream. Please try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _initializePlayer,
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.brandOrange,
            ),
            label: const Text(
              'RETRY',
              style: TextStyle(
                color: AppColors.brandOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          if (_hasError)
            _buildErrorState('Error')
          else if (_isInitializing || _chewieController == null)
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.brandOrange),
              ),
            )
          else
            Chewie(controller: _chewieController!),
        ],
      ),
    );
  }
}
