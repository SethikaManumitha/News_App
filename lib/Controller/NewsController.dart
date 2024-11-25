import '../Model/News.dart';
import '../Database/DatabaseHandler.dart';

class NewsController {
  final DatabaseHandler databaseHandler = DatabaseHandler();

  Future<void> insertNote(News news) async {
    await databaseHandler.insertNews(news);
  }
}