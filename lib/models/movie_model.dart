// lib/models/movie_model.dart
class MovieModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl; // Poster or Thumbnail
  final String? trailerUrl;
  final String category;
  final bool isBrandNew;
  final double progress; // For continue watching (0.0 to 1.0)

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.trailerUrl,
    required this.category,
    this.isBrandNew = false,
    this.progress = 0.0,
  });

  // Example factory for eventual API integration
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      trailerUrl: json['trailerUrl'] as String?,
      category: json['category'] as String,
      isBrandNew: json['isBrandNew'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});
}
