import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static const String DB_NAME = 'expense_tracker.db';
  static const String TABLE_NAME = 'expenses';

  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), DB_NAME);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $TABLE_NAME(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            category TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertExpense(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(TABLE_NAME, data);
  }

  static Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query(TABLE_NAME, orderBy: 'date DESC');
  }

  static Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateExpense(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(TABLE_NAME, data, where: 'id = ?', whereArgs: [id]);
  }
}
