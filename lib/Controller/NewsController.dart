import '../Model/News.dart';
import '../Database/DatabaseHandler.dart';

class NewsController {
  final DatabaseHandler databaseHandler = DatabaseHandler();

  Future<void> insertNews(News news) async {
    await databaseHandler.insertNews(news);
  }

  Future<void> removeNews(int id) async {
    await databaseHandler.deleteNews(id);
  }

  Future<List<News>> retrieveNews() async {
    return await databaseHandler.retrieveNews();
  }
}
