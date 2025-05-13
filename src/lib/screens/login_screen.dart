import 'package:flutter/material.dart';
import '/../main_screen.dart';
import 'signup_screen.dart';
import 'utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                "Usuário",
                controller: TextEditingController(),
                type: TextInputType.text,
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
              // Botão de login
              Utils.buildButton(
                text: "Entrar",
                width: 250,
                onPressed: () {
                  debugPrint("Fazendo Login...");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
              ),
              // Links
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Link para criar conta
                  TextButton(
                    onPressed: () => _criarConta(context),
                    child: Text("Crie um conta agora!"),
                  ),
                  // Link para recuperar senha
                  TextButton(
                    onPressed: () => _recuperarSenha(context),
                    child: Text("Esqueci minha senha!"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // footer
      bottomNavigationBar: Utils.buildFooter(),
    );
  }

  void _criarConta( BuildContext context) {
    debugPrint("Criando conta...");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void _recuperarSenha( BuildContext context) {
    debugPrint("Esqueci a senha...");
  }
}
