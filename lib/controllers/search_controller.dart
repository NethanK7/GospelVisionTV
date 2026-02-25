import 'package:flutter/material.dart';
import '../models/content_model.dart';

class ContentSearchController extends ChangeNotifier {
  String _query = '';
  List<ContentModel> _results = [];
  bool _isSearching = false;

  String get query => _query;
  List<ContentModel> get results => _results;
  bool get isSearching => _isSearching;

  void search(String query, List<ContentModel> allContent) {
    _query = query;
    if (query.isEmpty) {
      _results = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    final lowerQuery = query.toLowerCase();
    _results = allContent.where((content) {
      return content.title.toLowerCase().contains(lowerQuery) ||
          content.description.toLowerCase().contains(lowerQuery) ||
          content.category.toLowerCase().contains(lowerQuery) ||
          content.genres.any((g) => g.toLowerCase().contains(lowerQuery));
    }).toList();
    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    _isSearching = false;
    notifyListeners();
  }
}
