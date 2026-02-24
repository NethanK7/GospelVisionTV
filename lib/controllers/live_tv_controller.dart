import 'package:flutter/material.dart';

class LiveTvController extends ChangeNotifier {
  // Placeholder M3U8 for testing
  final String streamUrl = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8";

  bool isPlaying = false;
  bool isBuffering = false;

  // We will initialize video_player inside the View using this controller's URL
  // The state will be managed here if needed conceptually.

  void togglePlay(bool playing) {
    isPlaying = playing;
    notifyListeners();
  }

  void setBuffering(bool buffering) {
    isBuffering = buffering;
    notifyListeners();
  }
}
