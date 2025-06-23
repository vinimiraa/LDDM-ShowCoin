import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const _dbName = 'app.db';
  static const _dbVersion = 1;

  static const String userTable = 'User';
  static const String transactionTable = 'Transaction';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        // Ativa integridade referencial (foreign keys)
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUserTable(db);
    await _createTransactionTable(db);
    debugPrint('Database created with version $version');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adicionar lógica para atualizar o banco de dados
      debugPrint('Upgrading database from version $oldVersion to $newVersion');
    }
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE $userTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) NOT NULL,
        spending_limit REAL NOT NULL DEFAULT 0,
        profile_picture_url TEXT
      )
    ''');
  }

  Future<void> _createTransactionTable(Database db) async {
    await db.execute('''
      CREATE TABLE $transactionTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date DATE NOT NULL,
        name VARCHAR(255) NOT NULL,
        value REAL NOT NULL,
        amount INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  // Método utilitário para deletar o banco (testes)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
  }
}