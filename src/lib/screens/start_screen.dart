import 'package:flutter/material.dart';
import '/../main_screen.dart';
import 'utils.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // header
      // appBar: Utils.buildHeader(''),
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
              Utils.buildText(
                "Seu dinheiro sob controle, \nna palma da sua mão",
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                marginTop: 30,
                marginBottom: 60,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              // Botão de login
              Utils.buildButton(
                text: "Começar",
                width: 250,
                onPressed: () {
                  debugPrint("Começando no app ...");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // footer
      // bottomNavigationBar: Utils.buildFooter(),
    );
  }
}
