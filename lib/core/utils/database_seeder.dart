import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSeeder {
  static Future<void> seedInitialData({bool force = false}) async {
    final firestore = FirebaseFirestore.instance;

    // Seed Movies
    final moviesCount =
        (await firestore.collection('movies').get()).docs.length;
    if (moviesCount == 0 || force) {
      final List<Map<String, dynamic>> movies = [
        {
          'title': 'The Chosen: Episode 1',
          'imageUrl':
              'https://images.unsplash.com/photo-1512314889357-e157c22f938d?w=500',
          'videoUrl':
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          'description': 'A charismatic fisherman struggling with debt.',
          'createdAt': FieldValue.serverTimestamp(),
          'category': 'Series',
        },
        {
          'title': 'Miracle on Main St',
          'imageUrl':
              'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?w=500',
          'videoUrl':
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          'description': 'A story of faith and redemption in a small town.',
          'createdAt': FieldValue.serverTimestamp(),
          'category': 'Movie',
        },
      ];

      for (var movie in movies) {
        await firestore.collection('movies').add(movie);
      }
    }

    // Seed News
    final newsCount = (await firestore.collection('news').get()).docs.length;
    if (newsCount == 0 || force) {
      final List<Map<String, dynamic>> newsItems = [
        {
          'title': 'Global Youth Summit 2024',
          'imageUrl':
              'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=500',
          'description':
              'Join thousands of young believers for a weekend of worship.',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'New Mission Trip to Africa',
          'imageUrl':
              'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=500',
          'description':
              'Bringing hope and medical supplies to remote villages.',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var item in newsItems) {
        await firestore.collection('news').add(item);
      }
    }
  }
}
