import 'dart:core';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class QRCodeScreen extends StatefulWidget {
  final PersistentTabController controller;

  const QRCodeScreen({super.key, required this.controller});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen>
    with WidgetsBindingObserver {
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
            onDetect: (result) {
              getQRCodeInformation(result.barcodes.first.rawValue!);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> getQRCodeInformation(String url) async {
  if (url.isEmpty) {
    debugPrint("Empty URL!");
    return;
  }
  // debugPrint("URL: $url");

  var html = (await http.get(Uri.parse(url))).body;
  // debugPrint("HTML: $html");

  var list = parseHtml(html);
  // debugPrint("Lista: $list");

  for (var item in list) {
		// TODO: Adicionar lógica para salvar os dados no banco de dados
    debugPrint(item); // Print para debug
  }
}

List parseHtml(String html) {
  final document = parse(html);
  final table = document.querySelector("#myTable");

  List<String> items = [];
  var rows = table?.querySelectorAll("tr");
  for (var row in rows!) {
    var cells = row.querySelectorAll("td");
    if (cells.isNotEmpty) {
      var title = cells[0].querySelector("h7")?.text.trim() ?? "";
      var quantity = cells[1].text.trim();
      var value = cells[3].text.trim();

      var item = "$title - $quantity - $value";

      items.add(item);
    }
  }

  return items;
}