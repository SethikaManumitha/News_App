import '../Model/News.dart';
import '../Database/DatabaseHandler.dart';

class NewsController {
  final DatabaseHandler databaseHandler = DatabaseHandler();

  Future<void> insertNews(News news) async {
    await databaseHandler.insertNews(news);
    print("News ID: ${news.id}");
    print("News Title: ${news.title}");
    print("News Body: ${news.body}");
    print("News Date: ${news.date}");
    print("URL: ${news.imageUrl}");

  }

  Future<void> removeNews(String id) async {
    await databaseHandler.deleteNews(id);
    print("News ID: ${id}");
  }

  Future<List<News>> retrieveNews() async {
    return await databaseHandler.retrieveNews();
  }
}
