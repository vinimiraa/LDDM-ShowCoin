import 'package:flutter/material.dart';
import 'utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader("Configurações"),
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
            SwitchListTile(
              title: const Text("Receber Notificações"),
              value: notificationsEnabled,
              secondary: const Icon(Icons.notifications_active),
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                  debugPrint("Notificações ${value ? "ativadas" : "desativadas"}");
                });
              },
            ),
            SwitchListTile(
              title: const Text("Modo Escuro"),
              value: isDarkMode,
              secondary: const Icon(Icons.brightness_6),
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                  debugPrint("Modo ${isDarkMode ? "Escuro" : "Claro"} ativado");
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text("Importar Dados (CSV)"),
              onTap: _importarCSV,
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text("Exportar Dados (CSV)"),
              onTap: _exportarCSV,
            ),
          ],
        ),
      ),
    );
  }

  void _importarCSV() {
    debugPrint("Importando dados de um arquivo CSV...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV importado com sucesso!")),
    );
  }

  void _exportarCSV() {
    debugPrint("Exportando dados financeiros para CSV...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV exportado com sucesso!")),
    );
  }
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
              "Limite de Gastos",
              controller: TextEditingController(),
              type: TextInputType.number,
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

  void _atualizarPerfil() {
    debugPrint("Atualizando perfil...");
  }
}
