import 'package:flutter/foundation.dart';
import '../database/db.dart';

class TransactionController extends ChangeNotifier {
  List<Map<String, dynamic>> _transactions = [];

  List<Map<String, dynamic>> get transactions => _transactions;

  Future<void> loadTransactions() async {
    try {
      final db = await DatabaseHelper().database;
      final result = await db.rawQuery('''
        SELECT nome AS title, valor AS amount, data AS date
        FROM Transacao
        ORDER BY data DESC
      ''');

      _transactions = result;
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar transações: $e');
    }
  }
}

// Instância global para ser importada em qualquer lugar
final transactionController = TransactionController();
