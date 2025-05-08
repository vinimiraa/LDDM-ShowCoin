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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }

  void _exportarCSV() {
    // TODO: Implementar lógica real de exportação de dados financeiros.
    debugPrint("Exportando dados financeiros para CSV...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV exportado com sucesso!")),
    );
  }

  void _encerrarSessao() {
    debugPrint("Encerrando sessão...");
    // TODO: Redirecionar ou limpar dados se necessário
  }
}
