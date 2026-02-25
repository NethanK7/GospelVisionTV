// lib/models/content_model.dart

import 'package:flutter/material.dart';

enum ContentType { movie, series, documentary, sermon, worship, kids, podcast, liveEvent }

class ContentModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? backdropUrl;
  final String? trailerUrl;
  final String category;
  final List<String> genres;
  final String maturityRating;
  final String year;
  final String? duration;
  final int? seasons;
  final int? episodes;
  final double matchPercentage;
  final bool isBrandNew;
  final bool isOriginal;
  final double progress;
  final ContentType type;
  final String? cast;
  final String? director;
  final int? rank; // For Top 10

  ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.backdropUrl,
    this.trailerUrl,
    this.category = '',
    this.genres = const [],
    this.maturityRating = 'PG',
    this.year = '2024',
    this.duration,
    this.seasons,
    this.episodes,
    this.matchPercentage = 95.0,
    this.isBrandNew = false,
    this.isOriginal = false,
    this.progress = 0.0,
    this.type = ContentType.movie,
    this.cast,
    this.director,
    this.rank,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      backdropUrl: json['backdropUrl'] as String?,
      trailerUrl: json['trailerUrl'] as String?,
      category: json['category'] as String? ?? '',
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      maturityRating: json['maturityRating'] as String? ?? 'PG',
      year: json['year'] as String? ?? '2024',
      duration: json['duration'] as String?,
      seasons: json['seasons'] as int?,
      episodes: json['episodes'] as int?,
      matchPercentage: (json['matchPercentage'] as num?)?.toDouble() ?? 95.0,
      isBrandNew: json['isBrandNew'] as bool? ?? false,
      isOriginal: json['isOriginal'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      cast: json['cast'] as String?,
      director: json['director'] as String?,
      rank: json['rank'] as int?,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;

  CategoryModel({required this.id, required this.name, required this.imageUrl});
}

class ProfileModel {
  final String id;
  final String name;
  final Color color;
  final String? avatarUrl;
  final bool isKids;
  final IconData icon;

  ProfileModel({
    required this.id,
    required this.name,
    required this.color,
    this.avatarUrl,
    this.isKids = false,
    this.icon = Icons.person,
  });
}
