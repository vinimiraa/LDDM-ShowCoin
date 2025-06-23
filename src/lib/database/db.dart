import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const _dbName = 'app.db';
  static const _dbVersion = 1;

  static const String userTable = 'UsuarioLocal';
  static const String transactionTable = 'Transacao';

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
        nome VARCHAR(255) NOT NULL,
        limite_gastos REAL NOT NULL DEFAULT 0,
        foto_de_perfil TEXT
      )
    ''');
  }

  Future<void> _createTransactionTable(Database db) async {
    await db.execute('''
      CREATE TABLE $transactionTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL,
        nome VARCHAR(255) NOT NULL,
        valor REAL NOT NULL,
        usuario_id INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES UsuarioLocal(id)
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