import '../models/transaction_model.dart';
import 'db.dart';

class TransactionDB {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Insere uma nova transação
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.transactionTable, transaction.toMap());
  }
  
  /// Busca todas as transações de um usuário
  Future<List<TransactionModel>> getTransactions() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseHelper.transactionTable,
      orderBy: 'date DESC',
    );
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  /// Busca uma transação específica pelo ID
  Future<TransactionModel?> getTransactionById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseHelper.transactionTable,
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
      DatabaseHelper.transactionTable,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// Deleta uma transação pelo ID
  Future<int> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.transactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
