import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('storage.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE rooms (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE locations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      room_id INTEGER,
      name TEXT,
      FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      location_id INTEGER,
      name TEXT,
      description TEXT,
      FOREIGN KEY (location_id) REFERENCES locations (id) ON DELETE CASCADE
    )
    ''');
  }
}
