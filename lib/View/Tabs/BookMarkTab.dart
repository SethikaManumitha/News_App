import 'package:flutter/material.dart';
import '../../Controller/NewsController.dart';
import '../../Model/News.dart';
import '../NewsCard.dart';

class BookMarkTab extends StatefulWidget {
  const BookMarkTab({super.key});

  @override
  State<BookMarkTab> createState() => _BookMarkTabState();
}

class _BookMarkTabState extends State<BookMarkTab> {
  final NewsController newsController = NewsController();
  late Future<List<News>> _newsList;

  @override
  void initState() {
    super.initState();
    _newsList = newsController.retrieveNews();
  }


  void deleteBookmark(int newsId, int index) async {
    await newsController.removeNews(newsId);
    setState(() {
      _newsList = newsController.retrieveNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: FutureBuilder<List<News>>(
        future: _newsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Bookmarked News'));
          } else {
            // Display news in a list
            List<News> newsList = snapshot.data!;

            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];

                return Dismissible(
                  key: Key(news.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deleteBookmark(news.id!, index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bookmark removed')),
                    );
                  },
                  background: Container(
                    color: Colors.orange,
                    child: const Icon(Icons.delete, color: Colors.white, size: 40),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                  ),
                  child: NewsCard(
                    id: news.id!,
                    title: news.title,
                    body: news.body,
                    date: news.date,
                    imageUrl: news.imageUrl,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
