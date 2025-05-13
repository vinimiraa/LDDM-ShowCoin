import 'package:flutter/material.dart';
import 'transaction_details_screen.dart';
import 'utils.dart';
import '../database/db.dart';
import '../controllers/transaction_controller.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  List<Map<String, dynamic>> _transactions = [];

  void _onTransactionsChanged() {
    setState(() {
      _transactions = transactionController.transactions;
    });
  }

  @override
  void initState() {
    super.initState();
    transactionController.addListener(_onTransactionsChanged);
    transactionController.loadTransactions();
  }

  @override
  void dispose() {
    transactionController.removeListener(_onTransactionsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader('Extrato'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final t = _transactions[index];
          final title = t['title'] as String;
          final amount = t['amount'] as double;
          final date = t['date'] as String;
          final isPositive = amount >= 0;

          return _buildTransactionItem(context, title, amount, date, isPositive);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionDetailsScreen(isNewTransaction: true),
            ),
          );

          if (result == true) {
            await transactionController.loadTransactions();
          }
        },
        backgroundColor: AppColors.backgroundButton,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String title,
    double amount,
    String date,
    bool isPositive,
  ) {
    final icon = isPositive ? Icons.monetization_on : Icons.shopping_cart;

    return TextButton(
      onPressed: () async {
        final result = await Navigator.push(
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

        if (result == true) {
          await transactionController.loadTransactions();
        }
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
