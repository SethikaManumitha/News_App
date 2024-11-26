import 'package:flutter/material.dart';
import '../../Services/ApiService.dart';
import '../NewsCard.dart';

class SearchTab extends StatefulWidget {
  final String query;

  const SearchTab({super.key, this.query = ""});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<dynamic> articles = [];
  bool isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void didUpdateWidget(SearchTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) {
      fetchNewsByQuery(widget.query);
    }
  }

  Future<void> fetchNewsByQuery(String query) async {
    setState(() {
      isLoading = true;
    });

    List<dynamic> searchedArticles = [];

    if (query.isEmpty) {
      setState(() {
        articles = [];
        isLoading = false;
      });
      return;
    }

    searchedArticles = await _apiService.fetchNewsByQuery(query);

    setState(() {
      articles = searchedArticles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (articles.isEmpty) {
                    return const Center(child: Text("No articles found"));
                  } else {
                    return ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return NewsCard(
                          id: index,
                          title: article['title'] ?? 'No title',
                          body: article['description'] ?? 'No description',
                          date: article['publishedAt'] ?? 'No date',
                          imageUrl: article['urlToImage'] ?? 'https://via.placeholder.com/100',
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
