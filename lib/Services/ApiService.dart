import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = '8454dce4765c4d6ca2d1b3a853183fa8';
  static const String _baseUrl = 'https://newsapi.org/v2';

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

  Future<List<dynamic>> fetchNewsByCategory(String category) async {
    final String url = '$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      return [];
    }
  }
}