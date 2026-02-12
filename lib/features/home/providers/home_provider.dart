import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/content_item.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeState {
  final List<ContentItem> continueWatching;
  final List<ContentItem> trendingMovies;
  final List<ContentItem> graceAndTruth;
  final bool isLoading;

  HomeState({
    required this.continueWatching,
    required this.trendingMovies,
    required this.graceAndTruth,
    required this.isLoading,
  });

  factory HomeState.initial() => HomeState(
    continueWatching: [],
    trendingMovies: [],
    graceAndTruth: [],
    isLoading: false,
  );

  HomeState copyWith({
    List<ContentItem>? continueWatching,
    List<ContentItem>? trendingMovies,
    List<ContentItem>? graceAndTruth,
    bool? isLoading,
  }) {
    return HomeState(
      continueWatching: continueWatching ?? this.continueWatching,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      graceAndTruth: graceAndTruth ?? this.graceAndTruth,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState.initial()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);

    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch Trending Movies
      final moviesSnapshot = await firestore
          .collection('movies')
          .orderBy('createdAt', descending: true)
          .get();

      final trending = moviesSnapshot.docs.map((doc) {
        final data = doc.data();
        return ContentItem(
          id: doc.id,
          title: data['title'] ?? 'Untitled',
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? 'Movie',
        );
      }).toList();

      // Fetch News for "Grace & Truth" section
      final newsSnapshot = await firestore
          .collection('news')
          .orderBy('createdAt', descending: true)
          .get();

      final grace = newsSnapshot.docs.map((doc) {
        final data = doc.data();
        return ContentItem(
          id: doc.id,
          title: data['title'] ?? 'Untitled',
          imageUrl: data['imageUrl'] ?? '',
          category: 'News',
        );
      }).toList();

      // Mock data removed as requested by user ("i only wanna see blank everywhere")
      // Only real data from Firestore will be shown.

      state = state.copyWith(
        trendingMovies: trending,
        graceAndTruth: grace,
        continueWatching: [], // Blank as requested
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}
