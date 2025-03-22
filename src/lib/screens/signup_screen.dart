import 'package:flutter/material.dart';
import '/../main_screen.dart';
import 'utils.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // header
      appBar: Utils.buildHeader(''),
      // body
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Image.asset(
                  'assets/images/showcoin_icon.png',
                  width: 150, 
                ),
              ),
              // Campo de usuário
              Utils.buildInputField(
                "Nome Completo",
                controller: TextEditingController(),
                type: TextInputType.name,
                obscure: false,
                width: 300,
              ),
              // Campo de e-mail
              Utils.buildInputField(
                "Endereço de E-mail",
                controller: TextEditingController(),
                type: TextInputType.emailAddress,
                obscure: false,
                width: 300,
              ),
              // Campo de senha
              Utils.buildInputField(
                "Senha",
                controller: TextEditingController(),
                type: TextInputType.text,
                obscure: true,
                width: 300,
              ),
              // Campo de senha
              Utils.buildInputField(
                "Confirme a Senha",
                controller: TextEditingController(),
                type: TextInputType.text,
                obscure: true,
                width: 300,
              ),
              // Botão de login
              Utils.buildButton(
                text: "Criar Conta",
                width: 250,
                onPressed: () => _criarConta(context),
              ),
            ],
          ),
        ),
      ),
      // footer
      bottomNavigationBar: Utils.buildFooter(),
    );
  }

  // TODO: Implementar validação de campos e criação da conta
  void _criarConta(BuildContext context) {
    debugPrint("Criando conta...");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

}
