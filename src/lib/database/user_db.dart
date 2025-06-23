import '../models/user_model.dart';
import 'db.dart';

class UserDB {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insere um novo usuário
  Future<int> insertUser(LocalUser user) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.userTable, user.toMap());
  }

  // Retorna usuário pelo ID
  Future<LocalUser?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseHelper.userTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      final map = result.first;
      return LocalUser.fromMap(map);
    }
    return null;
  }

  /// Retorna o primeiro usuário (se o app só tem um usuário local)
  Future<LocalUser?> getFirstUser() async {
    final db = await _dbHelper.database;
    final result = await db.query(DatabaseHelper.userTable, limit: 1);
    if (result.isNotEmpty) {
      return LocalUser.fromMap(result.first);
    }
    return null;
  }

  /// Atualiza um usuário
  Future<int> updateUser(LocalUser user) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Deleta um usuário pelo ID
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}