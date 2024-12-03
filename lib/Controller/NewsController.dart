import '../Model/News.dart';
import '../Database/DatabaseHandler.dart';

class NewsController {
  final DatabaseHandler databaseHandler = DatabaseHandler();

  // Insert news into the database
  Future<void> insertNews(News news) async {
    await databaseHandler.insertNews(news);
  }

  // Remove news form database
  Future<void> removeNews(String id) async {
    await databaseHandler.deleteNews(id);
  }

  // Retrieve news
  Future<List<News>> retrieveNews() async {
    return await databaseHandler.retrieveNews();
  }
}
