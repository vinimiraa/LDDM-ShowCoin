import 'package:flutter/material.dart';
import 'utils.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader('QR Code'),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.qr_code,
                  size: 150,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Utils.buildButton(
              text: "Escaneie o QRCode",
              onPressed: _scanQRCode, // Chamada correta
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Implementar a abertura da câmera e leitura do QRCode
  void _scanQRCode() {
    debugPrint("Escaneie o QRCode"); // Print para debug
  }
}
