import 'package:flutter/material.dart';
import 'utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Utils.buildHeader('Home'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ! TESTE BOTÃO
            Utils.buildButton(text: "Teste", onPressed: _apertaBotao),

            // ! TESTE INPUT
            Utils.buildInputField(
              "Teste",
              controller: TextEditingController(),
              type: TextInputType.text,
              obscure: false,
            ),

            Utils.buildInputField(
              "Senha",
              controller: TextEditingController(),
              type: TextInputType.text,
              obscure: true,
              width: 300, // Define a largura do campo
            ),

            // ! TESTE ALERT
            ElevatedButton(
              onPressed: () {
                Utils.showAlertDialog(
                  context,
                  "Encerrar Sessão",
                  "Você tem certeza ?",
                  onConfirm: _apertaConfirmar,
                  confirmText: "Sei lá porra kkkkk",
                  cancelText: "Kero naum",
                );
              },
              child: Text("Teste Alerta"),
            ),
          ],
        ),
      ),
    );
  }

  void _apertaBotao() {
    debugPrint("Botão apertado (lá ele kkkkkkkkkkkkj)");
  }

  void _apertaConfirmar() {
    debugPrint("Sei lá porra apertado XDXDXD");
  }
}
