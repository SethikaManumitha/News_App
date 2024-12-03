import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/News.dart';
import '../Controller/NewsController.dart';
import 'ViewNewsScreen.dart';

class NewsCard extends StatefulWidget {
  final String id;
  final String title;
  final String body;
  final String date;
  final String imageUrl;

  const NewsCard({
    Key? key,
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final NewsController newsController = NewsController();
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
  }

  // Check if it is bookmarked
  void checkIfBookmarked() async {
    List<News> bookmarkedNews = await newsController.retrieveNews();
    setState(() {
      isBookmarked = bookmarkedNews.any((news) => news.id == widget.id);
    });
  }

  // Format the date
  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  void toggleBookmark() async {
    setState(() {
      isBookmarked = !isBookmarked;
    });

    if (isBookmarked) {
      News news = News(
        id: widget.id,
        title: widget.title,
        body: widget.body,
        date: widget.date,
        imageUrl: widget.imageUrl,
      );
      await newsController.insertNews(news);
    } else {
      await newsController.removeNews(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(widget.date);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewNewsScreen(
                id: widget.id,
                title: widget.title,
                body: widget.body,
                date: formattedDate,
                imageUrl: widget.imageUrl,
              ),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                widget.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.orange : Colors.grey,
              ),
              onPressed: toggleBookmark,
            ),
          ],
        ),
      ),
    );
  }
}
