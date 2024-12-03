import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _allArticles = [];
  List<NewsArticle> _bookmarkedArticles = [];
  bool _isLoading = false;
  String _defaultCategory = 'General';

  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;
  bool get isLoading => _isLoading;

  Future<void> fetchTopHeadlines() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allArticles = await NewsService().fetchTopHeadlinesByCategory(_defaultCategory);
      _articles = _allArticles;
    } catch (error) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterArticles(String query) {
    if (query.isEmpty) {
      _articles = _allArticles;
    } else {
      _articles = _allArticles
          .where((article) => article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchArticlesByCategory(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      _allArticles = await NewsService().fetchTopHeadlinesByCategory(category);
      _articles = _allArticles;
    } catch (error) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleBookmark(NewsArticle article) {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
  }

  bool isBookmarked(NewsArticle article) {
    return _bookmarkedArticles.contains(article);
  }

  void setDefaultCategory(String category) {
    _defaultCategory = category;
    fetchTopHeadlines();
  }
}
