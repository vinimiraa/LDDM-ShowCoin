import 'package:flutter/material.dart';
import 'transaction_details_screen.dart'; // Nova tela de detalhes
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
          _buildTransactionItem(context, 'Salário', 2000.00, '05 Set 2024', Icons.monetization_on, true),
          _buildTransactionItem(context, 'Alimentação', -45.00, '12 Set 2024', Icons.restaurant, false),
          _buildTransactionItem(context, 'Compras', -73.47, '19 Set 2024', Icons.shopping_bag, false),
          _buildTransactionItem(context, 'Pix', 25.00, '27 Set 2024', Icons.send, true),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO Lógica para criar uma nova transação
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionDetailsScreen(isNewTransaction: true)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, String title, double amount, String date, IconData icon, bool isPositive) {
    return TextButton(
      onPressed: () {
        // Navega para a tela de detalhes da transação
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              title: title,
              amount: amount,
              date: date,
              isPositive: isPositive,
            ),
          ),
        );
      },
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
