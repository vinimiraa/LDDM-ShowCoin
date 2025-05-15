import 'package:flutter/material.dart';
import 'package:src/database/db.dart'; // ajuste o import conforme seu projeto
import 'utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  String nomeUsuario = 'Carregando...';
  double limiteGastos = 0;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> usuarios = await db.query('UsuarioLocal', limit: 1);

    if (usuarios.isNotEmpty) {
      final usuario = usuarios.first;
      setState(() {
        nomeUsuario = usuario['nome'] ?? 'Fulano de Tal';
        final limiteValue = usuario['limite_gastos'];
          if (limiteValue != null) {
            if (limiteValue is int) {
              limiteGastos = limiteValue.toDouble();
            } else if (limiteValue is double) {
              limiteGastos = limiteValue;
            } else {
              limiteGastos = 0.0;
            }
          } else {
            limiteGastos = 0.0;
          }

      });
    } else {
      setState(() {
        nomeUsuario = 'Fulano de Tal';
        limiteGastos = 0.0;
      });
    }
  }

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
            Text(
              nomeUsuario,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Limite de Gastos: R\$ ${limiteGastos.toStringAsFixed(2)}",
                style: const TextStyle(color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Editar Perfil"),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      nomeAtual: nomeUsuario,
                      limiteAtual: limiteGastos,
                    ),
                  ),
                );

                if (result == true) {
                  _carregarPerfil();
                }
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

// ---------------------------------------------------------------

class EditProfileScreen extends StatefulWidget {
  final String nomeAtual;
  final double limiteAtual;

  const EditProfileScreen({
    super.key,
    required this.nomeAtual,
    required this.limiteAtual,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _limiteController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeAtual);
    _limiteController = TextEditingController(text: widget.limiteAtual.toString());
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _limiteController.dispose();
    super.dispose();
  }

  Future<void> _atualizarPerfil() async {
    final nome = _nomeController.text.trim();
    final limite = double.tryParse(_limiteController.text.trim());

    if (nome.isEmpty || limite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    final db = await DatabaseHelper().database;

    final count = await db.update(
      'UsuarioLocal',
      {
        'nome': nome,
        'limite_gastos': limite,
      },
      where: 'id = ?',
      whereArgs: [1], // ajuste o ID conforme necessário
    );

    if (count > 0) {
      debugPrint('Perfil atualizado com sucesso');
      Navigator.pop(context, true);
    } else {
      debugPrint('Erro ao atualizar perfil');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar perfil.")),
      );
    }
  }

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
              controller: _nomeController,
              type: TextInputType.text,
              obscure: false,
            ),
            Utils.buildInputField(
              "Limite de Gastos",
              controller: _limiteController,
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
}
