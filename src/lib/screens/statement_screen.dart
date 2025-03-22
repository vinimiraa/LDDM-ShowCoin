import 'package:flutter/material.dart';
import 'utils.dart';

class StatementScreen extends StatelessWidget {
  const StatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader('Extrato'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTransactionItem('Salário', 2000.00, '05 Set 2024', Icons.monetization_on, true),
          _buildTransactionItem('Alimentação', -45.00, '12 Set 2024', Icons.restaurant, false),
          _buildTransactionItem('Compras', -73.47, '19 Set 2024', Icons.shopping_bag, false),
          _buildTransactionItem('Pix', 25.00, '27 Set 2024', Icons.send, true),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, double amount, String date, IconData icon, bool isPositive) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.amber),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(
          "${isPositive ? '+' : '-'} R\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
