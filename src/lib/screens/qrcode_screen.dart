import 'dart:core';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:src/database/transaction_db.dart';
import 'package:src/models/transaction_model.dart';
import 'package:src/controllers/transaction_controller.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class QRCodeScreen extends StatefulWidget {
  final PersistentTabController controller;

  const QRCodeScreen({super.key, required this.controller});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> with WidgetsBindingObserver {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_handleTabChange);
    _scannerController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.controller.index == 2) {
      _scannerController.start(); // Ativa a câmera ao entrar na aba
    } else {
      _scannerController.stop(); // Desativa a câmera ao sair da aba
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader('QR Code'),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (result) async {
              await getQRCodeInformation(result.barcodes.first.rawValue!);
              _scannerController.stop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('QR Code lido com sucesso!'),
                ),
              );
              
              Future.delayed(const Duration(seconds: 1), () {
                widget.controller.jumpToTab(1);
              });
            },
          ),
        ],
      ),
    );
  }
}

Future<void> getQRCodeInformation(String url) async {
  if (url.isEmpty) {
    debugPrint("Erro: URL do QR Code está vazia.");
    return;
  }

  var htmlContent = (await http.get(Uri.parse(url))).body;

  var transactionsList = parseHtml(htmlContent);

  final transactionDB = TransactionDB();
  for (var item in transactionsList) {
    await transactionDB.insertTransaction(item);
  }

  // Atualiza a tela de transações em tempo real
  await transactionController.loadTransactions();
}

List<TransactionModel> parseHtml(String html) {
  final document = parse(html);
  final table = document.querySelector("#myTable");

  List<TransactionModel> transactions = [];
  var rows = table?.querySelectorAll("tr");
  for (var row in rows ?? []) {
    var cells = row.querySelectorAll("td");
    if (cells.isNotEmpty) {
      var name = cells[0].querySelector("h7")?.text.trim() ?? "";
      var amountStr = cells[1].text.trim();
      var valueStr = cells[3].text.trim();

      // Parse amount and value to appropriate types
      int? amount = int.tryParse(amountStr.replaceAll(RegExp(r'[^0-9]'), ''));
      double? value = double.tryParse(valueStr.replaceAll(RegExp(r'[^0-9.,]'), '').replaceAll(',', '.'));

      transactions.add(
        TransactionModel(
          name: name,
          amount: amount ?? 1,
          value: value ?? 0.0,
          date: DateTime.now().toIso8601String(),
        ),
      );
    }
  }

  // Normaliza todas as transações para o formato padrão
  return transactions.map(TransactionModel.normalize).toList();
}
