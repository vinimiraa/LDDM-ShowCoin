import '../models/transaction_model.dart';
import 'db.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  Future<int> deleteTransaction(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.transactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Exporta transações para um arquivo CSV
  Future<String> exportToCSV() async {
    final transactions = await getTransactions();

    // Cria as linhas do CSV
    List<List<dynamic>> csvData = [
      // Cabeçalho
      ['id', 'name', 'amount', 'value', 'date'],
      // Dados
      ...transactions.map((t) => [
            t.id ?? '',
            t.name,
            t.amount,
            t.value,
            t.date,
          ]),
    ];

    // Converte para CSV
    String csv = const ListToCsvConverter().convert(csvData);

    // Pega diretório do app
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/transacoes.csv';

    // Salva o arquivo
    final file = File(path);
    await file.writeAsString(csv);

    return path;
  }

  /// Importa transações de um arquivo CSV
  Future<void> importFromCSV(File file) async {
    final content = await file.readAsString();
    final rows = const CsvToListConverter().convert(content, eol: '\n');

    if (rows.isEmpty) return;

    // Ignora cabeçalho
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      final transaction = TransactionModel(
        name: row[1]?.toString() ?? '',
        amount: int.tryParse(row[2]?.toString() ?? '1') ?? 1,
        value: double.tryParse(row[3]?.toString() ?? '0') ?? 0.0,
        date: row[4]?.toString() ?? DateTime.now().toIso8601String(),
      );

      await insertTransaction(transaction);
    }
  }
}
