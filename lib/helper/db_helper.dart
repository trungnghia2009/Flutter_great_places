import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> dataBase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      // TODO: create new db if not exist
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_long REAL, address TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    await dataBase()
      ..insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
  }

  static Future<List<Map<String, dynamic>>> get(String table) async {
    final db = await dataBase();
    return db.query(table);
  }

  static Future<void> delete(String title) async {
    final db = await dataBase();
    return db.execute('DELETE FROM user_places WHERE title = "$title"');
  }
}
