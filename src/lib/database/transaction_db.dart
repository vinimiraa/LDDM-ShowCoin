import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import 'db.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TransactionDB {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Insere uma nova transação
  Future<int> insertTransaction(TransactionModel transaction) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(
        DatabaseHelper.transactionTable,
        transaction.toMap(),
      );
    } catch (e, s) {
      debugPrint('Erro ao inserir transação: $e\n$s');
      return 0;
    }
  }

  /// Busca todas as transações de um usuário
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        DatabaseHelper.transactionTable,
        orderBy: 'date DESC',
      );
      return result.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e, s) {
      debugPrint('Erro ao buscar transações: $e\n$s');
      return [];
    }
  }

  /// Busca uma transação específica pelo ID
  Future<TransactionModel?> getTransactionById(int id) async {
    try {
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
    } catch (e, s) {
      debugPrint('Erro ao buscar transação por ID: $e\n$s');
      return null;
    }
  }

  /// Atualiza uma transação
  Future<int> updateTransaction(TransactionModel transaction) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(
        DatabaseHelper.transactionTable,
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } catch (e, s) {
      debugPrint('Erro ao atualizar transação: $e\n$s');
      return 0;
    }
  }

  /// Deleta uma transação pelo ID
  Future<int> deleteTransaction(String id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        DatabaseHelper.transactionTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, s) {
      debugPrint('Erro ao deletar transação: $e\n$s');
      return 0;
    }
  }

  /// Exporta transações para um arquivo CSV
  Future<String> exportToCSV() async {
    try {
      final transactions = await getTransactions();
      List<List<dynamic>> csvData = [
        ['id', 'name', 'amount', 'value', 'date'],
        ...transactions.map(
          (t) => [t.id ?? '', t.name, t.amount, t.value, t.date],
        ),
      ];
      String csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/transacoes.csv';
      final file = File(path);
      await file.writeAsString(csv);
      return path;
    } catch (e, s) {
      debugPrint('Erro ao exportar CSV: $e\n$s');
      rethrow;
    }
  }

  /// Importa transações de um arquivo CSV
  Future<void> importFromCSV(File file) async {
    try {
      final content = await file.readAsString();
      final rows = const CsvToListConverter().convert(content, eol: '\n');
      if (rows.isEmpty) return;
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        try {
          final transaction = TransactionModel(
            name: row[1]?.toString() ?? '',
            amount: int.tryParse(row[2]?.toString() ?? '1') ?? 1,
            value: double.tryParse(row[3]?.toString() ?? '0') ?? 0.0,
            date: row[4]?.toString() ?? DateTime.now().toIso8601String(),
          );
          await insertTransaction(transaction);
        } catch (e) {
          debugPrint('Erro ao importar linha do CSV: $e | Linha: $row');
        }
      }
    } catch (e, s) {
      debugPrint('Erro ao importar CSV: $e\n$s');
      rethrow;
    }
  }
}
