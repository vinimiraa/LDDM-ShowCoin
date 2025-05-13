import 'package:flutter/foundation.dart';
import '../database/db.dart';

class TransactionController extends ChangeNotifier {
  List<Map<String, dynamic>> _transactions = [];

  List<Map<String, dynamic>> get transactions => _transactions;

  Future<void> loadTransactions() async {
    try {
      final db = await DatabaseHelper().database;
      final result = await db.rawQuery(''' 
        SELECT Item.nome AS title, Item.valor AS amount, Compra.data AS date
        FROM Item
        INNER JOIN Possui ON Item.id = Possui.item_id
        INNER JOIN Compra ON Compra.id = Possui.compra_id
        ORDER BY Compra.data DESC
      ''');

      _transactions = result;
      notifyListeners();
    } catch (e) {
      // Aqui você pode adicionar um tratamento de erro (ex: log, toast, etc)
      print('Erro ao carregar transações: $e');
    }
  }
}

// Instância global para ser importada em qualquer lugar
final transactionController = TransactionController();
