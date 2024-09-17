import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'auth_db.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE,
          password TEXT
        )
      ''');
    });
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient!.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    var dbClient = await db;
    var result = await dbClient!.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    var dbClient = await db;
    var result = await dbClient!.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updatePassword(String email, String newPassword) async {
    var dbClient = await db;
    return await dbClient!.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
