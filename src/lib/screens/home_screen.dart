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

            // ! TESTE TEXT
            Utils.buildText(
              "Teste de texto", 
              color: AppColors.textSecondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              marginTop: 20,
              marginBottom: 20,
            ),

            Utils.buildText(
              "Teste de texto 2", 
              color: const Color.fromARGB(255, 157, 212, 47),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              marginTop: 5,
              marginBottom: 5,
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
