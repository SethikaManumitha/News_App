import 'package:flutter/material.dart';

import '../../Services/ApiService.dart';
import '../NewsCard.dart';
import '../../Model/News.dart';

class SearchTab extends StatefulWidget {
  final String query;

  const SearchTab({super.key, this.query = ""});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<News> articles = [];
  bool isLoading = false;
  final ApiService _apiService = ApiService();

  // List of categories
  final List<String> categories = [
    "General",
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology"
  ];

  String selectedCategory = "";

  @override
  void didUpdateWidget(SearchTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) {
      fetchNewsByQuery(widget.query);
    }
  }

  // Fetch news by query
  Future<void> fetchNewsByQuery(String query) async {
    setState(() {
      isLoading = true;
      selectedCategory = "";
    });

    if (query.isEmpty) {
      setState(() {
        articles = [];
        isLoading = false;
      });
      return;
    }

    final searchedArticles = await _apiService.fetchNewsByQuery(query);

    setState(() {
      articles = searchedArticles
          .asMap()
          .entries
          .map((entry) => News(
        id: 'search${entry.key}',
        title: entry.value['title'] ?? 'No title',
        body: entry.value['description'] ?? 'No description',
        date: entry.value['publishedAt'],
        imageUrl: entry.value['urlToImage'] ?? '',
      ))
          .toList();
      isLoading = false;
    });
  }

  // Fetch news by category
  Future<void> fetchNewsByCategory(String category) async {
    setState(() {
      isLoading = true;
      selectedCategory = category;
    });

    final categoryArticles = await _apiService.fetchNewsByCategory(category.toLowerCase());

    setState(() {
      articles = categoryArticles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Category buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: categories.map((category) {
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ElevatedButton(
                      onPressed: () => fetchNewsByCategory(category),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.orange : Colors.white,
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Article list
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (articles.isEmpty) {
                  return const Center(child: Text("No articles found"));
                } else {
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final News article = articles[index];
                      return NewsCard(
                        id: article.id,
                        title: article.title,
                        body: article.body,
                        date: article.date,
                        imageUrl: article.imageUrl.isNotEmpty
                            ? article.imageUrl
                            : 'https://via.placeholder.com/100',
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
