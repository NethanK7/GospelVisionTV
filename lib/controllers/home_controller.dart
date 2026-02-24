import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class HomeController extends ChangeNotifier {
  // Dummy Data for Categories
  final List<CategoryModel> categories = [
    CategoryModel(id: '1', name: 'Trending Now'),
    CategoryModel(id: '2', name: 'Sermons'),
    CategoryModel(id: '3', name: 'Documentaries'),
    CategoryModel(id: '4', name: 'Kids'),
  ];

  // Dummy Data for Hero (Featured)
  MovieModel? featuredMovie = MovieModel(
    id: 'f1',
    title: 'The Gospel Vision Experience',
    description:
        'Join us live for an incredible journey of faith and inspiration.',
    imageUrl:
        'https://images.unsplash.com/photo-1544427920-c49ccf111be1?w=800&q=80',
    category: 'Trending Now',
    isBrandNew: true,
  );

  // Dummy Data for Continue Watching
  List<MovieModel> continueWatching = [
    MovieModel(
      id: 'cw1',
      title: 'Faith in Action',
      description: 'Part 3: The power of community.',
      imageUrl:
          'https://images.unsplash.com/photo-1510590337019-5ef8d3d32116?w=400&q=80',
      category: 'Sermons',
      progress: 0.65,
    ),
    MovieModel(
      id: 'cw2',
      title: 'Historical Discoveries',
      description: 'Uncovering the ancient paths.',
      imageUrl:
          'https://images.unsplash.com/photo-1627916606041-0bfac94d50ff?w=400&q=80',
      category: 'Documentaries',
      progress: 0.20,
    ),
  ];

  // Dummy Data for Trending
  List<MovieModel> trendingMovies = [
    MovieModel(
      id: 't1',
      title: 'Grace & Truth',
      description: 'Understanding the biblical foundations.',
      imageUrl:
          'https://images.unsplash.com/photo-1438283173091-5dbf5c5a3206?w=400&q=80',
      category: 'Trending Now',
    ),
    MovieModel(
      id: 't2',
      title: 'Kids Club Live',
      description: 'Fun, songs, and lessons.',
      imageUrl:
          'https://images.unsplash.com/photo-1519340333755-56e9c1d04579?w=400&q=80',
      category: 'Kids',
      isBrandNew: true,
    ),
    MovieModel(
      id: 't3',
      title: 'Testimonies',
      description: 'Stories of changed lives.',
      imageUrl:
          'https://images.unsplash.com/photo-1473629474775-db32f7fb7058?w=400&q=80',
      category: 'Trending Now',
    ),
  ];

  bool isLoading = false;

  HomeController() {
    _loadData(); // Simulated API fetch
  }

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
  }

  // Refresh mechanism
  Future<void> refreshData() async {
    await _loadData();
  }
}
