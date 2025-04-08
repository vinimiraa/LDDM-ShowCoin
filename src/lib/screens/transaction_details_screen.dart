import 'package:flutter/material.dart';
import 'utils.dart';

class TransactionDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.header,
        title: Text(
          isNewTransaction ? 'Nova Transação' : 'Detalhes da Transação',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isNewTransaction) ...[
              Text('Descrição: $title', style: const TextStyle(fontSize: 18)),
              Text(
                'Valor: R\$${amount?.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              Text('Data: $date', style: const TextStyle(fontSize: 18)),
              Text(
                'Tipo: ${isPositive == true ? 'Receita' : 'Despesa'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Utils.buildButton(
                    text: "Editar",
                    onPressed: _editarTransacao,
                  ),
                  Utils.buildButton(
                    text: "Excluir",
                    onPressed: _excluirTransacao,
                  ),
                ],
              ),
            ] else ...[
              // Formulário para criar uma nova transação
              Utils.buildInputField(
                "Descrição",
                controller: TextEditingController(),
                type: TextInputType.text,
                obscure: false,
                width: 300,
              ),
              Utils.buildInputField(
                "Valor",
                controller: TextEditingController(),
                type: TextInputType.number,
                obscure: false,
                width: 300,
              ),
              Utils.buildInputField(
                "Data",
                controller: TextEditingController(),
                type: TextInputType.datetime,
                obscure: false,
                width: 300,
              ),
              Utils.buildButton(
                text: "Salvar",
                width: 250,
                onPressed: _salvarNovaTransacao,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // TODO: Implementar a lógica para editar a transação
  void _editarTransacao() {
    // Lógica para editar a transação
    debugPrint( "Editando transação..." );
  }

  // TODO: Implementar a lógica para excluir a transação
  void _excluirTransacao() {
    // Lógica para excluir a transação
    debugPrint( "Excluindo transação..." );
  }

  // TODO: Implementar a lógica para salvar uma nova transação
  void _salvarNovaTransacao() {
    // Lógica para salvar a nova transação
    debugPrint( "Salvando nova transação..." );
  }
}
