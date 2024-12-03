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

  String _sortOption = 'Date';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchAndSortNews();
  }

  // Sort news based on title and date
  void _fetchAndSortNews() {
    _newsList = newsController.retrieveNews().then((newsList) {
      newsList.sort((a, b) {
        if (_sortOption == 'Date') {
          return _isAscending
              ? a.date.compareTo(b.date)
              : b.date.compareTo(a.date);
        } else if (_sortOption == 'Title') {
          return _isAscending
              ? a.title.compareTo(b.title)
              : b.title.compareTo(a.title);
        }
        return 0;
      });
      return newsList;
    });
  }

  void deleteBookmark(String newsId) async {
    await newsController.removeNews(newsId);
    setState(() {
      _fetchAndSortNews();
    });
  }

  void _updateSort(String option, bool isAscending) {
    setState(() {
      _sortOption = option;
      _isAscending = isAscending;
      _fetchAndSortNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Date Ascending') {
                _updateSort('Date', true);
              } else if (value == 'Date Descending') {
                _updateSort('Date', false);
              } else if (value == 'Title Ascending') {
                _updateSort('Title', true);
              } else if (value == 'Title Descending') {
                _updateSort('Title', false);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Date Ascending',
                child: Text('Date Ascending'),
              ),
              const PopupMenuItem(
                value: 'Date Descending',
                child: Text('Date Descending'),
              ),
              const PopupMenuItem(
                value: 'Title Ascending',
                child: Text('Title Ascending'),
              ),
              const PopupMenuItem(
                value: 'Title Descending',
                child: Text('Title Descending'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<News>>(
        future: _newsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Bookmarked News'));
          } else {
            List<News> newsList = snapshot.data!;

            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];

                // Remove an article
                return Dismissible(
                  key: Key(news.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deleteBookmark(news.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bookmark removed')),
                    );
                  },
                  background: Container(
                    color: Colors.orange,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 40),
                  ),
                  child: NewsCard(
                    id: news.id,
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
