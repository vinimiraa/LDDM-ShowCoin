import 'package:flutter/material.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import 'transaction_details_screen.dart';
import 'utils.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  List<TransactionModel> _transactions = [];

  void _onTransactionsChanged() {
    setState(() {
      _transactions = transactionController.transactions
          .map((map) => TransactionModel.fromMap(map))
          .toList();
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
      body: _transactions.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma transação registrada.',
                style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final t = _transactions[index];
                return _buildTransactionItem(t);
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

  Widget _buildTransactionItem(TransactionModel t) {
    final isPositive = t.value >= 0;
    final icon = isPositive ? Icons.attach_money : Icons.shopping_cart;
    final color = isPositive
        ? AppColors.contentColorGreen
        : AppColors.contentColorRed;

    return Card(
      color: AppColors.backgroundNavBar,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          t.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          t.date,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Text(
          "${isPositive ? '' : '-'} R\$${t.value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                transaction: t,
                isNewTransaction: false,
              ),
            ),
          );

          if (result == true) {
            await transactionController.loadTransactions();
          }
        },
      ),
    );
  }
}
