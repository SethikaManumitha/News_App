import 'package:flutter/material.dart';
import '../Model/News.dart';
import '../Controller/NewsController.dart';

class ViewNewsScreen extends StatefulWidget {
  final String id;
  final String title;
  final String body;
  final String date;
  final String imageUrl;

  const ViewNewsScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<ViewNewsScreen> createState() => _ViewNewsScreenState();
}

class _ViewNewsScreenState extends State<ViewNewsScreen> {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.white,
            ),
            onPressed: toggleBookmark,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      Text(
                        widget.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 40,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                widget.body,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
