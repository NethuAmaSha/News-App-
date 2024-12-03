import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  final String apiKey = 'c01f894879c64a05a7696ba73eee2108';

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    try {
      final response = await http.get(
        Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final List articles = json.decode(response.body)['articles'];
        return articles.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        _showErrorToast('Failed to load news. Status code: ${response.statusCode}');
        throw Exception('Failed to load news');
      }
    } catch (error) {
      _showErrorToast('Error: Unable to fetch news. Please check your connection.');
      rethrow;
    }
  }

  Future<List<NewsArticle>> fetchTopHeadlinesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final List articles = json.decode(response.body)['articles'];
        return articles.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        _showErrorToast('Failed to load news for category $category. Status code: ${response.statusCode}');
        throw Exception('Failed to load news');
      }
    } catch (error) {
      _showErrorToast('Error: Unable to fetch news for category $category. Please check your connection.');
      rethrow;
    }
  }

  Future<List<NewsArticle>> searchArticles(String query) async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List articles = json.decode(response.body)['articles'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      _showErrorToast('Failed to load search results');
      throw Exception('Failed to fetch articles');
    }
  }

  Future<List<NewsArticle>> fetchTrendingNews() async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List articles = json.decode(response.body)['articles'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      _showErrorToast('Failed to load trending news');
      throw Exception('Failed to fetch trending news');
    }
  }


  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
