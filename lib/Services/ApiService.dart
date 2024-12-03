import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/News.dart';

class ApiService {
  static const String _apiKey = '8a4bbdfa425c4afe909c196d3a6211fd';
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Fetch top news
  Future<List<dynamic>> fetchTopNews() async {
    const String url = '$_baseUrl/everything?q=trending&sortBy=popularity&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      return [];
    }
  }

  // Fetch latest news
  Future<List<dynamic>> fetchLatestNews() async {
    const String url = '$_baseUrl/top-headlines?country=us&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      return [];
    }
  }

  // Fetch news by query
  Future<List<dynamic>> fetchNewsByQuery(String query) async {
    final String url = '$_baseUrl/everything?q=$query&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      return [];
    }
  }

  // Fetch news by category
  Future<List<News>> fetchNewsByCategory(String category) async {
    final String url = '$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articles = data['articles'] ?? [];

      return articles.map<News>((article) {
        return News(
          id: '${category}_${articles.indexOf(article)}',
          title: article['title'] ?? 'No Title',
          body: article['description'] ?? 'No Description',
          date: article['publishedAt'] ?? 'No Date',
          imageUrl: article['urlToImage'] ?? '',
        );
      }).toList();
    } else {
      return [];
    }
  }
}
