import 'package:flutter/material.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("QRcode", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
