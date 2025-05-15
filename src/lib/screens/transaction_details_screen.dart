import 'package:flutter/material.dart';
import 'utils.dart';  // Ajuste o caminho se necessário
import '../database/db.dart';  // Ajuste o caminho se necessário
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String? title;
  final double? amount;
  final String? date;
  final bool? isPositive;  // manteve isPositive
  final bool isNewTransaction;

  const TransactionDetailsScreen({
    super.key,
    this.title,
    this.amount,
    this.date,
    this.isPositive,
    this.isNewTransaction = false,
  });

  @override
  _TransactionDetailsScreenState createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!widget.isNewTransaction) {
      _descriptionController.text = widget.title ?? '';
      _amountController.text = widget.amount?.toStringAsFixed(2) ?? '';
      _dateController.text = widget.date ?? '';
    } else {
      _dateController.text =
          DateFormat('dd/MM/yyyy').format(DateTime.now()); // data atual
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
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
        padding: const EdgeInsets.all(16.0),
        child: widget.isNewTransaction
            ? _buildNewTransactionForm()
            : _buildTransactionDetails(),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descrição: ${widget.title}', style: const TextStyle(fontSize: 18)),
        Text('Valor: R\$${widget.amount?.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18)),
        Text('Data: ${widget.date}', style: const TextStyle(fontSize: 18)),
        Text(
          'Tipo: ${widget.isPositive == true ? 'Receita' : 'Despesa'}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Utils.buildButton(
                text: "Editar",
                onPressed: () {
                  _showEditDialog();
                },
              ),
              const SizedBox(height: 10),
              Utils.buildButton(
                text: "Excluir",
                onPressed: _excluirTransacao,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewTransactionForm() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Utils.buildInputField(
            "Descrição",
            controller: _descriptionController,
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
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                });
              }
            },
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
            onPressed: _salvarNovaTransacao,
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    _descriptionController.text = widget.title ?? '';
    _amountController.text = widget.amount?.toStringAsFixed(2) ?? '';
    _dateController.text = widget.date ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Transação"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Utils.buildInputField(
                  "Descrição",
                  controller: _descriptionController,
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
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateFormat('dd/MM/yyyy').parse(_dateController.text),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
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
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editarTransacao();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _salvarNovaTransacao() async {
    final description = _descriptionController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    final date = _dateController.text.trim();

    if (description.isEmpty || amount == null || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    await db.insert(
      'Transacao',
      {
        'nome': description,
        'valor': amount,
        'data': date,
        'usuario_id': 1, // Ajuste conforme seu usuário
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transação salva com sucesso!')),
    );

    Navigator.pop(context, true);
  }

  void _editarTransacao() async {
    final description = _descriptionController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    final date = _dateController.text.trim();

    if (description.isEmpty || amount == null || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    // Busca pelo nome antigo (widget.title) para editar
    final transacaoResult = await db.query(
      'Transacao',
      where: 'nome = ?',
      whereArgs: [widget.title],
    );

    if (transacaoResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transação não encontrada.")),
      );
      return;
    }

    final int transacaoId = transacaoResult.first['id'] as int;

    await db.update(
      'Transacao',
      {
        'nome': description,
        'valor': amount,
        'data': date,
      },
      where: 'id = ?',
      whereArgs: [transacaoId],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transação editada com sucesso!')),
    );

    Navigator.pop(context, true);
  }

  void _excluirTransacao() async {
    final description = widget.title ?? '';

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Descrição da transação não informada.")),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    final transacaoResult = await db.query(
      'Transacao',
      where: 'nome = ?',
      whereArgs: [description],
    );

    if (transacaoResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transação não encontrada.")),
      );
      return;
    }

    final int transacaoId = transacaoResult.first['id'] as int;

    await db.delete(
      'Transacao',
      where: 'id = ?',
      whereArgs: [transacaoId],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transação excluída com sucesso!')),
    );

    Navigator.pop(context, true);
  }
}
