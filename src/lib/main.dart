import 'package:flutter/material.dart';
import 'package:src/screens/start_screen.dart';
import 'package:src/screens/utils.dart';
import 'package:src/database/db.dart';
import 'package:sqflite/sqflite.dart';
import 'controllers/transaction_controller.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
final transactionController = TransactionController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb)
  {
    final dbPath = await getDatabasesPath();
    final fullPath = dbPath + '/app.db';

    // Checa se o arquivo do banco já existe
    final bool dbExists = await databaseExists(fullPath);

    // Inicializa o banco (cria se não existir)
    var db = await DatabaseHelper().database;

    debugPrint('Banco de dados inicializado com sucesso!');
    debugPrint('Caminho do banco de dados: $dbPath');

    if (dbExists) {
      // Se banco existe, checa se tem usuário
      await _criarUsuarioPadraoSeNaoExistir(db);
    } else {
      // Banco não existia, mas acabou de ser criado pelo DatabaseHelper.onCreate,
      // então insere o usuário padrão
      await _criarUsuarioPadraoSeNaoExistir(db);
    }
  } else {
    // Se for web, não usa o banco local
    debugPrint('Executando em ambiente web, sem banco local.');
  }
  runApp(const MyApp());
}

Future<void> _criarUsuarioPadraoSeNaoExistir(Database db) async {
  final usuarios = await db.query('UsuarioLocal');
  if (usuarios.isEmpty) {
    await db.insert('UsuarioLocal', {
      'nome': 'Fulano de Tal',
      'limite_gastos': 0,
      'foto_de_perfil': null,
    });
    debugPrint('Usuário padrão criado.');
  } else {
    debugPrint('Usuário já existente.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Show Coin',
      navigatorObservers: [routeObserver], // Inscreve o RouteObserver
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter',
      ),
      home: const StartScreen(),
    );
  }
}
