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
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE UsuarioLocal (
        id INTEGER PRIMARY KEY,
        nome TEXT,
        limite_gastos REAL,
        foto_de_perfil TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Transacao (
        id INTEGER PRIMARY KEY,
        data TEXT,
        nome TEXT,
        valor REAL,
        usuario_id INTEGER,
        FOREIGN KEY (usuario_id) REFERENCES UsuarioLocal(id)
      )
    ''');
  }
}
