import 'package:flutter/material.dart';
import 'utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader("Configurações"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
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
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text("Exportar Dados (CSV)"),
                onTap: _exportarCSV,
              ),
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text("Importar Dados (CSV)"),
                onTap: _importarCSV,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportarCSV() {
    debugPrint("Exportando dados financeiros para CSV...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV exportado com sucesso!")),
    );
  }

  void _importarCSV() {
    debugPrint("Importando dados de um arquivo CSV...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV importado com sucesso!")),
    );
  }

}
