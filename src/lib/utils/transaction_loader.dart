import '../database/db.dart';

/// Retorna uma lista com as transações (nome, valor, data)
Future<List<Map<String, dynamic>>> carregarTransacoesExternamente() async {
  try {
    final db = await DatabaseHelper().database;
    final result = await db.rawQuery(''' 
      SELECT Item.nome AS title, Item.valor AS amount, Compra.data AS date
      FROM Item
      INNER JOIN Possui ON Item.id = Possui.item_id
      INNER JOIN Compra ON Compra.id = Possui.compra_id
      ORDER BY Compra.data DESC
    ''');
    return result;
  } catch (e, s) {
    print('Erro ao carregar transações externamente: $e\n$s');
    return [];
  }
}
