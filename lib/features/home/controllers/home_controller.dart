import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch Trending Movies
      final moviesSnapshot = await firestore
          .collection('movies')
          .orderBy('createdAt', descending: true)
          .get();

      _trendingMovies = moviesSnapshot.docs.map((doc) {
        final data = doc.data();
        return ContentItem(
          id: doc.id,
          title: data['title'] ?? 'Untitled',
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? 'Movie',
        );
      }).toList();

      // Fetch News for "Grace & Truth" section (as an example)
      final newsSnapshot = await firestore
          .collection('news')
          .orderBy('createdAt', descending: true)
          .get();

      _graceAndTruth = newsSnapshot.docs.map((doc) {
        final data = doc.data();
        return ContentItem(
          id: doc.id,
          title: data['title'] ?? 'Untitled',
          imageUrl: data['imageUrl'] ?? '',
          category: 'News',
        );
      }).toList();

      // Mock continue watching for now
      _continueWatching = [
        ContentItem(
          id: 'mock_1',
          title: 'The Chosen - S1 E1',
          imageUrl:
              'https://images.unsplash.com/photo-1512314889357-e157c22f938d?w=500',
          progress: 0.7,
          category: 'Series',
        ),
      ];
    } catch (e) {
      debugPrint('Error loading Firestore data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
