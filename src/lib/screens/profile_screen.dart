import 'package:flutter/material.dart';
import 'utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader("Perfil"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 10),
            const Text(
              "Fulano De Tal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("ID: 00000001", style: TextStyle(color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Editar Perfil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Alterar Senha"),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Alterar Senha"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Utils.buildInputField(
                              "Senha Atual",
                              controller: TextEditingController(),
                              type: TextInputType.text,
                              obscure: true,
                            ),
                            Utils.buildInputField(
                              "Nova Senha",
                              controller: TextEditingController(),
                              type: TextInputType.text,
                              obscure: true,
                            ),
                            Utils.buildInputField(
                              "Confirmar Senha",
                              controller: TextEditingController(),
                              type: TextInputType.text,
                              obscure: true,
                            ),
                          ],
                        ),
                        actions: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Utils.buildButton(
                                text: "Cancelar",
                                onPressed: () => Navigator.pop(context),
                                color: Colors.grey,
                                width: 160,
                              ),
                              const SizedBox(height: 10),
                              Utils.buildButton(
                                text: "Atualizar",
                                onPressed: _atualizarSenha,
                                color: AppColors.backgroundButton,
                                width: 160,
                              ),
                            ],
                          ),
                        ],
                      ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text("Sair", style: TextStyle(color: Colors.red)),
              onTap: () {
                Utils.showAlertDialog(
                  context,
                  "Encerrar Sessão",
                  "Você tem certeza que deseja sair?",
                  onConfirm: _encerrarSessao,
                  confirmText: "Sim, Encerrar Sessão",
                  cancelText: "Cancelar",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: Implementar lógica para atualizar a senha
void _atualizarSenha() {
  debugPrint("Atualizando senha...");
}

// TODO: Implementar lógica para encerrar a sessão
void _encerrarSessao() {
  debugPrint("Encerrando sessão...");
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader("Editar Perfil"),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Utils.buildInputField(
              "Nome",
              controller: TextEditingController(),
              type: TextInputType.text,
              obscure: false,
            ),
            Utils.buildInputField(
              "Telefone",
              controller: TextEditingController(),
              type: TextInputType.phone,
              obscure: false,
            ),
            Utils.buildInputField(
              "E-Mail",
              controller: TextEditingController(),
              type: TextInputType.emailAddress,
              obscure: false,
            ),
            const SizedBox(height: 20),
            Utils.buildButton(
              text: "Atualizar Perfil",
              onPressed: () {
                Utils.showAlertDialog(
                  context,
                  "Atualizar Perfil",
                  "Deseja realmente atualizar o perfil?",
                  onConfirm: _atualizarPerfil,
                  confirmText: "Sim, Atualizar",
                  cancelText: "Cancelar",
                );
              },
              color: AppColors.backgroundButton,
              width: 160,
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Implementar lógica para atualizar o perfil
  void _atualizarPerfil() {
    debugPrint("Atualizando perfil...");
  }
}
