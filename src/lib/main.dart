import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:src/screens/start_screen.dart';
import 'package:src/screens/utils.dart';
import 'package:src/database/user_db.dart';
import 'package:src/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await solicitarPermissaoNotificacao();
    if (!kIsWeb) {
      await _setupLocalDatabase();
    } else {
      debugPrint('Executando na web. Banco local não utilizado.');
    }
  } catch (e, s) {
    debugPrint('Erro na inicialização do app: $e\n$s');
  }
  runApp(const MyApp());
}

Future<void> solicitarPermissaoNotificacao() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> _setupLocalDatabase() async {
  try {
    final dbPath = await getDatabasesPath();
    final fullPath = '$dbPath/app.db';
    final bool dbExists = await databaseExists(fullPath);
    debugPrint('Banco de dados inicializado em: $fullPath');
    final userDB = UserDB();
    if (!dbExists) {
      await _criarUsuarioPadrao(userDB);
    } else {
      final existingUser = await userDB.getFirstUser();
      if (existingUser == null) {
        await _criarUsuarioPadrao(userDB);
      } else {
        debugPrint('Usuário local já existente: ${existingUser.name}');
      }
    }
  } catch (e, s) {
    debugPrint('Erro ao configurar banco de dados local: $e\n$s');
  }
}

Future<void> _criarUsuarioPadrao(UserDB userDB) async {
  try {
    final user = LocalUserModel.defaultUser();
    await userDB.insertUser(user);
    debugPrint('Usuário padrão criado.');
  } catch (e, s) {
    debugPrint('Erro ao criar usuário padrão: $e\n$s');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Show Coin',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter',
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
      home: const StartScreen(),
    );
  }
}
