import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class AppDatabase {

  Future<Database> _getDatabase() async {
    return openDatabase(
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
      version: 1,
    );
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
  }

  Future<List<String>> getLastQueries() async {
    final database = await _getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
        'last_query',
        columns: ['query'],
        orderBy: 'timestamp DESC',
        limit: 10
    );
    return List.generate(maps.length, (i) {
      return maps[i]['query'];
    });
  }
}
