import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'compras.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Compra (
        id INTEGER PRIMARY KEY,
        data TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Item (
        id INTEGER PRIMARY KEY,
        nome TEXT,
        valor REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE Possui (
        compra_id INTEGER,
        item_id INTEGER,
        PRIMARY KEY (compra_id, item_id),
        FOREIGN KEY (compra_id) REFERENCES Compra(id),
        FOREIGN KEY (item_id) REFERENCES Item(id)
      )
    ''');
  }
}
