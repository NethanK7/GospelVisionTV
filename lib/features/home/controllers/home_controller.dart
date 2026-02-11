import 'package:flutter/material.dart';
import '../../../core/models/content_item.dart';

class HomeController extends ChangeNotifier {
  List<ContentItem> _continueWatching = [];
  List<ContentItem> _trendingMovies = [];
  List<ContentItem> _graceAndTruth = [];
  bool _isLoading = false;

  List<ContentItem> get continueWatching => _continueWatching;
  List<ContentItem> get trendingMovies => _trendingMovies;
  List<ContentItem> get graceAndTruth => _graceAndTruth;
  bool get isLoading => _isLoading;

  HomeController() {
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;

    _continueWatching = [
      ContentItem(
        id: '1',
        title: 'The Chosen - S1 E1',
        imageUrl:
            'https://images.unsplash.com/photo-1512314889357-e157c22f938d?w=500',
        progress: 0.7,
        category: 'Series',
      ),
      ContentItem(
        id: '2',
        title: 'Worship Night 2024',
        imageUrl:
            'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=500',
        progress: 0.3,
        category: 'Worship',
      ),
    ];

    _trendingMovies = List.generate(
      5,
      (i) => ContentItem(
        id: 'trending_$i',
        title: 'Production ${i + 1}',
        imageUrl:
            'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?w=500&q=$i',
        category: 'Movie',
      ),
    );

    _graceAndTruth = List.generate(
      5,
      (i) => ContentItem(
        id: 'grace_$i',
        title: 'Episode ${i + 1}',
        imageUrl:
            'https://images.unsplash.com/photo-1543165796-5426273eaec3?w=500&q=$i',
        category: 'Series',
      ),
    );

    _isLoading = false;
    notifyListeners();
  }
}
