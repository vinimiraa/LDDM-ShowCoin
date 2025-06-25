import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedDate;

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

  List<TransactionModel> get _filteredTransactions {
    if (_selectedDate == null) return _transactions;

    return _transactions.where((tx) {
      final txDate = DateTime.tryParse(tx.date);
      if (txDate == null) return false;
      return txDate.year == _selectedDate!.year &&
          txDate.month == _selectedDate!.month &&
          txDate.day == _selectedDate!.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader('Extrato'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'Filtrar por data'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10),
                if (_selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Limpar filtro',
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                      });
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTransactions.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma transação registrada.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final t = _filteredTransactions[index];
                      return _buildTransactionItem(t);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
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
            color: Color.fromRGBO(244, 67, 54, 1), // Vermelho
          ),
        ),
      ),
    );
  }
}
