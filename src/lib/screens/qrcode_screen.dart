import 'dart:core';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:src/database/transaction_db.dart';
import 'package:src/models/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'utils.dart';

class QRCodeScreen extends StatefulWidget {
  final PersistentTabController controller;

  const QRCodeScreen({super.key, required this.controller});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

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
      _scannerController.start();
    } else {
      _scannerController.stop();
    }
  }

  Future<void> _onQRCodeDetected(String qrValue) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    _scannerController.stop();

    // Mostra popup de carregando
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Lendo dados...",
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );

    try {
      await getQRCodeInformation(qrValue);

      // Redireciona para a aba de transações
      widget.controller.index = 2;
    } catch (e) {
      debugPrint('Erro ao ler QR: $e');

      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.background,
            title: const Text(
              "Erro",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: const Text(
              "Não foi possível ler o QR Code.\nTente novamente.",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _scannerController.start();
                  setState(() {
                    _isProcessing = false;
                  });
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        );
      }
    } finally {
      // Sempre fecha o popup de carregando, se estiver aberto
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      setState(() {
        _isProcessing = false;
      });
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
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final qrValue = barcode.rawValue;
              if (qrValue != null) {
                _onQRCodeDetected(qrValue);
              }
            },
          ),
          // Retângulo de foco
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Texto com fundo branco
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Aponte a câmera para o QR Code',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
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

  var html = (await http.get(Uri.parse(url))).body;
  var transactionsList = parseHtml(html);

  final transactionDB = TransactionDB();
  for (var item in transactionsList) {
    await transactionDB.insertTransaction(item);
  }
}

List<TransactionModel> parseHtml(String html) {
  final document = parse(html);
  final table = document.querySelector("#myTable");
  final dateStr =
      document
          .querySelectorAll('#accordion table')[5]
          .querySelector("tbody td:nth-child(4)")
          ?.text
          .trim() ??
      "";

  // Conversão para ISO 8601
  String dateIso = "";
  if (dateStr.isNotEmpty) {
    try {
      final inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
      final dateTime = inputFormat.parse(dateStr);
      dateIso = dateTime.toIso8601String();
    } catch (e) {
      dateIso = "";
    }
  }

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
      double? value = double.tryParse(
        valueStr.replaceAll(RegExp(r'[^0-9.,]'), '').replaceAll(',', '.'),
      );

      transactions.add(
        TransactionModel(
          name: name,
          amount: amount ?? 1,
          value: value ?? 0.0,
          date: dateIso.isNotEmpty ? dateIso : DateTime.now().toIso8601String(),
        ),
      );
    }
  }

  return transactions;
}
