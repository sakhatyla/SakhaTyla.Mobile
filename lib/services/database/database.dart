import 'dart:async';

import 'package:sakhatyla/services/api/api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  Future<Database>? _db;

  final _favoriteArticleAddedController = StreamController<int>.broadcast();
  final _favoriteArticleRemovedController = StreamController<int>.broadcast();

  Stream<int> get onFavoriteArticleAdded =>
      _favoriteArticleAddedController.stream;
  Stream<int> get onFavoriteArticleRemoved =>
      _favoriteArticleRemovedController.stream;

  void _createTableFavoriteV2(Batch batch) {
    batch.execute('''
      CREATE TABLE "favorite_word" (
          "id" INTEGER NOT NULL UNIQUE,
          "title"	TEXT NOT NULL,
	        "text" TEXT NOT NULL,
	        "from" TEXT NOT NULL,
	        "to" TEXT NOT NULL,
	        "category" TEXT,
	        "timestamp"	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );
      ''');
  }

  // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md
  Future<Database> _getDatabase() async {
    if (_db == null) {
      _db = openDatabase(
        join(await getDatabasesPath(), 'sakhatyla.db'),
        onCreate: (db, version) async {
          var batch = db.batch();
          batch.execute('''
            CREATE TABLE "last_query" (
	          "query"	TEXT NOT NULL UNIQUE,
	          "timestamp"	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          );
          ''');
          _createTableFavoriteV2(batch);
          await batch.commit();
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          var batch = db.batch();
          if (newVersion == 2) {
            _createTableFavoriteV2(batch);
          }
          await batch.commit();
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
        conflictAlgorithm: ConflictAlgorithm.replace);

    database.execute('''
      DELETE FROM last_query WHERE timestamp < (SELECT timestamp FROM last_query ORDER BY timestamp DESC LIMIT 1 OFFSET 9);
      ''');
  }

  Future<List<String>> getLastQueries() async {
    final database = await _getDatabase();
    final List<Map<String, dynamic>> maps = await database.query('last_query',
        columns: ['query'], orderBy: 'timestamp DESC');
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
        conflictAlgorithm: ConflictAlgorithm.replace);
    _favoriteArticleAddedController.add(article.id);
  }

  Future<void> removeFavoriteArticle(int id) async {
    final database = await _getDatabase();
    await database.delete('favorite_word', where: 'id = ?', whereArgs: [id]);
    _favoriteArticleRemovedController.add(id);
  }

  Future<bool> isArticleFavorite(int id) async {
    final database = await _getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
        'favorite_word',
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [id]);
    return maps.isNotEmpty;
  }

  Future<List<Article>> getFavoriteArticles({List<int>? articleIds}) async {
    final database = await _getDatabase();
    String? where;
    List<Object?>? whereArgs;
    if (articleIds != null) {
      where = 'id IN (${List.filled(articleIds.length, '?').join(',')})';
      whereArgs = articleIds;
    }
    final List<Map<String, dynamic>> maps = await database.query(
      'favorite_word',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      var article = maps[i];
      return Article(
        id: article['id'],
        title: article['title'],
        text: article['text'],
        fromLanguageName: article['from'],
        toLanguageName: article['to'],
        collapsed: false,
        isFavorite: true,
      );
    });
  }

  dispose() {
    _favoriteArticleAddedController.close();
    _favoriteArticleRemovedController.close();
  }
}
