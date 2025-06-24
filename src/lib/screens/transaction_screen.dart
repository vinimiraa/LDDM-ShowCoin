import 'package:flutter/material.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import 'transaction_details_screen.dart';
import 'utils.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<TransactionModel> _transactions = [];

  void _onTransactionsChanged() {
    setState(() {
      _transactions =
          transactionController.transactions
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
      body:
          _transactions.isEmpty
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
              builder:
                  (context) =>
                      const TransactionDetailsScreen(isNewTransaction: true),
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
    return TextButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => TransactionDetailsScreen(
                  transaction: t,
                  isNewTransaction: false,
                ),
          ),
        );

        if (result == true) {
          await transactionController.loadTransactions();
        }
      },
      child: ListTile(
        leading: const Icon(Icons.shopping_cart, size: 40, color: Colors.amber),
        title: Text(
          t.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          t.date,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Text(
          "- R\$${t.value.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(244, 67, 54, 1), // Vermelho antigo
          ),
        ),
      ),
    );
  }
}
