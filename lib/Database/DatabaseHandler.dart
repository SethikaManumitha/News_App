import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/News.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'news.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE news(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                body TEXT NOT NULL,
                date TEXT NOT NULL,
                imageUrl TEXT NOT NULL)''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertNews(News news) async {
    final Database db = await initializeDB();
    return await db.insert('news', news.toMap());
  }


  Future<List<News>> retrieveNews() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('news');
    return queryResult.map((e) => News.fromMap(e)).toList();
  }

  // Delete a News record by ID
  Future<void> deleteNews(int id) async {
    final db = await initializeDB();
    await db.delete(
      'news',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
