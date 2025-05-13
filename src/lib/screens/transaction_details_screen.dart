import 'package:flutter/material.dart';
import 'utils.dart';  // Certifique-se de que o Utils está correto
import '../database/db.dart';  // Certifique-se de que o caminho do DB está correto
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String? title;
  final double? amount;
  final String? date;
  final bool? isPositive;
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

  int? compraId;
  int? itemId;

  @override
  void initState() {
    super.initState();

    if (!widget.isNewTransaction) {
      _descriptionController.text = widget.title ?? '';
      _amountController.text = widget.amount?.toStringAsFixed(2) ?? '';
      _dateController.text = widget.date ?? '';
      compraId = widget.isPositive != null ? 1 : 2;
      itemId = widget.isPositive != null ? 1 : 2;
    } else {
      _dateController.text =
          DateFormat('dd/MM/yyyy').format(DateTime.now()); // Preenche com data atual
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isNewTransaction) ...[
              Text('Descrição: ${widget.title}', style: const TextStyle(fontSize: 18)),
              Text(
                'Valor: R\$${widget.amount?.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
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
                      onPressed: _editarTransacao,
                    ),
                    const SizedBox(height: 10),
                    Utils.buildButton(
                      text: "Excluir",
                      onPressed: _excluirTransacao,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Center(
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
                    Utils.buildButton(
                      text: "Salvar",
                      width: 250,
                      onPressed: _salvarNovaTransacao,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _salvarNovaTransacao() async {
    final description = _descriptionController.text;
    final amount = double.tryParse(_amountController.text);
    final date = _dateController.text;

    if (description.isEmpty || amount == null || date.isEmpty) {
      debugPrint("Preencha todos os campos corretamente.");
      return;
    }

    final db = await DatabaseHelper().database;

    final compraId = await db.insert(
      'Compra',
      {'data': date},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final itemId = await db.insert(
      'Item',
      {'nome': description, 'valor': amount},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'Possui',
      {
        'compra_id': compraId,
        'item_id': itemId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    Navigator.pop(context, true);

    debugPrint("Transação salva com sucesso!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transação salva com sucesso!')),
    );
  }

  void _editarTransacao() async {
    final description = _descriptionController.text;
    final amount = double.tryParse(_amountController.text);
    final date = _dateController.text;

    if (description.isEmpty || amount == null || date.isEmpty) {
      debugPrint("Preencha todos os campos corretamente.");
      return;
    }

    final db = await DatabaseHelper().database;

    final itemResult = await db.query(
      'Item',
      where: 'nome = ?',
      whereArgs: [description],
    );

    if (itemResult.isEmpty) {
      debugPrint("Item não encontrado.");
      return;
    }

    final itemId = itemResult.first['id'];

    final compraResult = await db.query(
      'Possui',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );

    if (compraResult.isEmpty) {
      debugPrint("Compra não encontrada.");
      return;
    }

    final compraId = compraResult.first['compra_id'];

    await db.update(
      'Compra',
      {'data': date},
      where: 'id = ?',
      whereArgs: [compraId],
    );

    await db.update(
      'Item',
      {'nome': description, 'valor': amount},
      where: 'id = ?',
      whereArgs: [itemId],
    );

    debugPrint("Transação editada com sucesso!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transação editada com sucesso!')),
    );
  }

  void _excluirTransacao() async {
    final description = _descriptionController.text;

    if (description.isEmpty) {
      debugPrint("Descrição não encontrada.");
      return;
    }

    final db = await DatabaseHelper().database;

    final itemResult = await db.query(
      'Item',
      where: 'nome = ?',
      whereArgs: [description],
    );

    if (itemResult.isEmpty) {
      debugPrint("Item não encontrado.");
      return;
    }

    final itemId = itemResult.first['id'];

    final compraResult = await db.query(
      'Possui',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );

    if (compraResult.isEmpty) {
      debugPrint("Compra não encontrada.");
      return;
    }

    final compraId = compraResult.first['compra_id'];

    await db.delete(
      'Possui',
      where: 'compra_id = ?',
      whereArgs: [compraId],
    );

    await db.delete(
      'Item',
      where: 'id = ?',
      whereArgs: [itemId],
    );

    await db.delete(
      'Compra',
      where: 'id = ?',
      whereArgs: [compraId],
    );

    debugPrint("Transação excluída com sucesso!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transação excluída com sucesso!')),
    );

    Navigator.pop(context, true);
  }
}
