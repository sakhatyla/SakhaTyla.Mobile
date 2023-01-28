import 'package:sakhatyla/services/api/api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class AppDatabase {
  Future<Database>? _db;

  // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md
  Future<Database> _getDatabase() async {
    if (_db == null) {
      _db = openDatabase(
        join(await getDatabasesPath(), 'sakhatyla.db'),
        onCreate: (db, version) {
          return db.execute(
            '''
        CREATE TABLE "last_query" (
	        "query"	TEXT NOT NULL UNIQUE,
	        "timestamp"	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
        ''',
          );
        },
        onUpgrade: (db, oldVersion, newVersion) {
          if (newVersion == 2) {
              return db.execute(
                '''
                CREATE TABLE "favorite_word" (
                  "id" INTEGER NOT NULL UNIQUE,
	                "title"	TEXT NOT NULL,
	                "text" TEXT NOT NULL,
	                "from" TEXT NOT NULL,
	                "to" TEXT NOT NULL,
	                "category" TEXT
                );
                '''
              );
          }
        },
        version: 2,
      );
    }
    return _db!;
  }

  Future<void> addLastQuery(String query) async {
    final database = await _getDatabase();

    await database.insert(
        'last_query',
        {
          'query': query,
        },
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    database.execute(
      '''
      DELETE FROM last_query WHERE timestamp < (SELECT timestamp FROM last_query ORDER BY timestamp DESC LIMIT 1 OFFSET 9);
      '''
    );
  }

  Future<List<String>> getLastQueries() async {
    final database = await _getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
        'last_query',
        columns: ['query'],
        orderBy: 'timestamp DESC'
    );
    return List.generate(maps.length, (i) {
      return maps[i]['query'];
    });
  }

  Future<void> addFavoriteArticle(Article article) async {
    final database = await _getDatabase();
    await database.insert(
        'favorite_word',
        {
          'id': article.id,
          'title': article.title,
          'text': article.text,
          'from': article.fromLanguageName,
          'to': article.toLanguageName,
          'category': article.categoryName
        },
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> removeFavoriteArticle(int id) async {
    final database = await _getDatabase();
    await database.delete('favorite_word', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isArticleFavorite(int id) async {
    final database = await _getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
        'favorite_word',
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [id]
    );
    return maps.isNotEmpty;
  }
}
