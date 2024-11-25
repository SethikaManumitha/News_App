import 'package:flutter/material.dart';
import '../../Services/ApiService.dart';
import '../NewsCard.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<dynamic> articles = [];
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  // Fetch news data based on category
  Future<void> fetchNewsData(String category) async {
    setState(() {
      isLoading = true;
    });

    List<dynamic> fetchedArticles = [];

    if (category.isEmpty) {
      setState(() {
        articles = [];
        isLoading = false;
      });
      return;
    }

    if (["business", "entertainment", "general", "health", "science", "sports", "technology"]
        .contains(category)) {
      fetchedArticles = await _apiService.fetchNewsByCategory(category);
    } else {
      // Fetch by default category if no matching category
      fetchedArticles = await _apiService.fetchNewsByCategory("general");
    }

    setState(() {
      articles = fetchedArticles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Buttons to fetch articles by category
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => fetchNewsData("business"),
                  child: const Text("Business"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchNewsData("entertainment"),
                  child: const Text("Entertainment"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchNewsData("general"),
                  child: const Text("General"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchNewsData("health"),
                  child: const Text("Health"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchNewsData("science"),
                  child: const Text("Science"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchNewsData("sports"),
                  child: const Text("Sports"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchNewsData("technology"),
                  child: const Text("Technology"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Display loading indicator or articles
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