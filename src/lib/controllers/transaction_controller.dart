import 'package:flutter/foundation.dart';
import '../database/db.dart';

class TransactionController extends ChangeNotifier {
  List<Map<String, dynamic>> _transactions = [];

  List<Map<String, dynamic>> get transactions => _transactions;

  Future<void> loadTransactions() async {
    try {
      final db = await DatabaseHelper().database;
      final result = await db.rawQuery('''
        SELECT name, value, date
        FROM Transaction
        ORDER BY date DESC
      ''');

      _transactions = result;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar transações: $e');
    }
  }
}

// Instância global para ser importada em qualquer lugar
final transactionController = TransactionController();
