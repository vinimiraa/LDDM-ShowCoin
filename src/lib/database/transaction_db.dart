import '../models/transaction_model.dart';
import 'db.dart';

class TransactionDB {
  static const String table = 'Transacao';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Insere uma nova transação
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.insert(table, transaction.toMap());
  }

  /// Busca todas as transações de um usuário
  Future<List<TransactionModel>> getTransactions({required int userId}) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      table,
      where: 'usuario_id = ?',
      whereArgs: [userId],
      orderBy: 'data DESC',
    );
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  /// Busca uma transação específica pelo ID
  Future<TransactionModel?> getTransactionById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return TransactionModel.fromMap(result.first);
    }
    return null;
  }

  /// Atualiza uma transação
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      table,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// Deleta uma transação pelo ID
  Future<int> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Deleta todas as transações de um usuário
  Future<int> deleteAllTransactionsByUser(int userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      table,
      where: 'usuario_id = ?',
      whereArgs: [userId],
    );
  }
}
