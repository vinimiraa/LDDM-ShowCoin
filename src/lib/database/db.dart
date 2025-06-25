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
  static const String transactionTable = 'Transactions';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDatabase();
      return _database!;
    } catch (e, s) {
      debugPrint('Erro ao inicializar o banco de dados: $e\n$s');
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e, s) {
      debugPrint('Erro ao abrir banco de dados: $e\n$s');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await _createUserTable(db);
      await _createTransactionTable(db);
      debugPrint('Database created with version $version');
    } catch (e, s) {
      debugPrint('Erro ao criar tabelas: $e\n$s');
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < 2) {
        debugPrint(
          'Upgrading database from version $oldVersion to $newVersion',
        );
        // Adicione lógica de upgrade aqui
      }
    } catch (e, s) {
      debugPrint('Erro ao atualizar banco de dados: $e\n$s');
      rethrow;
    }
  }

  Future<void> _createUserTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE $userTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(255) NOT NULL,
          spending_limit REAL NOT NULL DEFAULT 0,
          profile_picture_url TEXT
        )
      ''');
    } catch (e, s) {
      debugPrint('Erro ao criar tabela User: $e\n$s');
      rethrow;
    }
  }

  Future<void> _createTransactionTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE $transactionTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(255) NOT NULL,
          value REAL NOT NULL,
          date DATE NOT NULL,
          amount INTEGER NOT NULL DEFAULT 1
        )
      ''');
    } catch (e, s) {
      debugPrint('Erro ao criar tabela Transactions: $e\n$s');
      rethrow;
    }
  }

  // Método utilitário para deletar o banco (testes)
  Future<void> deleteDatabaseFile() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      await deleteDatabase(path);
      debugPrint('Banco de dados deletado com sucesso.');
    } catch (e, s) {
      debugPrint('Erro ao deletar banco de dados: $e\n$s');
      rethrow;
    }
  }
}
