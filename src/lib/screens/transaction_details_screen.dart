import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/transaction_db.dart';
import '../models/transaction_model.dart';
import 'utils.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final TransactionModel? transaction;
  final bool isNewTransaction;

  const TransactionDetailsScreen({
    super.key,
    this.transaction,
    required this.isNewTransaction,
  });

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  final TransactionDB _transactionDB = TransactionDB();

  @override
  void initState() {
    super.initState();

    if (widget.isNewTransaction) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    } else {
      _nameController.text = widget.transaction?.name ?? '';
      _amountController.text = widget.transaction?.value.toString() ?? '';
      _dateController.text = widget.transaction?.date ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.header,
        title: Text(
          widget.isNewTransaction ? 'Nova Transação' : 'Detalhes da Transação',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.isNewTransaction ? _buildForm() : _buildDetails(),
      ),
    );
  }

  Widget _buildForm() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Utils.buildInputField(
            "Descrição",
            controller: _nameController,
            type: TextInputType.text,
            obscure: false,
            width: 300,
          ),
          Utils.buildInputField(
            "Valor",
            controller: _amountController,
            type: TextInputType.number,
            obscure: false,
            width: 300,
          ),
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: Utils.buildInputField(
                "Data",
                controller: _dateController,
                type: TextInputType.datetime,
                obscure: false,
                width: 300,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Utils.buildButton(
            text: "Salvar",
            width: 250,
            onPressed: _saveTransaction,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    final t = widget.transaction!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descrição: ${t.name}', style: const TextStyle(fontSize: 18)),
        Text('Valor: R\$ ${t.value.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
        Text('Data: ${t.date}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Utils.buildButton(
                text: "Editar",
                onPressed: _showEditDialog,
              ),
              const SizedBox(height: 10),
              Utils.buildButton(
                text: "Excluir",
                onPressed: _deleteTransaction,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    DateTime initialDate;
    try {
      initialDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
    } catch (_) {
      initialDate = DateTime.now();
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _saveTransaction() async {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    final date = _dateController.text.trim();

    if (name.isEmpty || amount == null || date.isEmpty) {
      _showError("Preencha todos os campos corretamente.");
      return;
    }

    final newTransaction = TransactionModel(
      id: null,
      name: name,
      value: amount,
      date: date,
    );

    await _transactionDB.insertTransaction(newTransaction);

    _showSuccess('Transação salva com sucesso!');
    Navigator.pop(context, true);
  }

  Future<void> _editTransaction() async {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    final date = _dateController.text.trim();

    if (name.isEmpty || amount == null || date.isEmpty) {
      _showError("Preencha todos os campos corretamente.");
      return;
    }

    final updatedTransaction = widget.transaction!.copyWith(
      name: name,
      value: amount,
      date: date,
    );

    await _transactionDB.updateTransaction(updatedTransaction);

    _showSuccess('Transação editada com sucesso!');
    Navigator.pop(context, true);
  }

  Future<void> _deleteTransaction() async {
    if (widget.transaction == null) return;

    await _transactionDB.deleteTransaction(widget.transaction!.id! as int);

    _showSuccess('Transação excluída com sucesso!');
    Navigator.pop(context, true);
  }

  void _showEditDialog() {
    _nameController.text = widget.transaction?.name ?? '';
    _amountController.text = widget.transaction?.value.toString() ?? '';
    _dateController.text = widget.transaction?.date ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Transação'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Utils.buildInputField(
                "Descrição",
                controller: _nameController,
                type: TextInputType.text,
                obscure: false,
                width: 300,
              ),
              Utils.buildInputField(
                "Valor",
                controller: _amountController,
                type: TextInputType.number,
                obscure: false,
                width: 300,
              ),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: Utils.buildInputField(
                    "Data",
                    controller: _dateController,
                    type: TextInputType.datetime,
                    obscure: false,
                    width: 300,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editTransaction();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
