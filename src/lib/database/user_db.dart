import '../models/user_model.dart';
import 'db.dart';
import 'package:flutter/foundation.dart';

class UserDB {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insere um novo usuário
  Future<int> insertUser(LocalUserModel user) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(DatabaseHelper.userTable, user.toMap());
    } catch (e, s) {
      debugPrint('Erro ao inserir usuário: $e\n$s');
      return 0;
    }
  }

  // Retorna usuário pelo ID
  Future<LocalUserModel?> getUserById(int id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        DatabaseHelper.userTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (result.isNotEmpty) {
        final map = result.first;
        return LocalUserModel.fromMap(map);
      }
      return null;
    } catch (e, s) {
      debugPrint('Erro ao buscar usuário por ID: $e\n$s');
      return null;
    }
  }

  /// Retorna o primeiro usuário (se o app só tem um usuário local)
  Future<LocalUserModel?> getFirstUser() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(DatabaseHelper.userTable, limit: 1);
      if (result.isNotEmpty) {
        return LocalUserModel.fromMap(result.first);
      }
      return null;
    } catch (e, s) {
      debugPrint('Erro ao buscar primeiro usuário: $e\n$s');
      return null;
    }
  }

  /// Atualiza um usuário
  Future<int> updateUser(LocalUserModel user) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(
        DatabaseHelper.userTable,
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e, s) {
      debugPrint('Erro ao atualizar usuário: $e\n$s');
      return 0;
    }
  }

  // Deleta um usuário pelo ID
  Future<int> deleteUser(int id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        DatabaseHelper.userTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, s) {
      debugPrint('Erro ao deletar usuário: $e\n$s');
      return 0;
    }
  }
}