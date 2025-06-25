import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:src/screens/start_screen.dart';
import 'package:src/screens/utils.dart';
import 'package:src/database/user_db.dart';
import 'package:src/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:src/service/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o serviço de notificações
  await NotificationService.initialize();

  if (!kIsWeb) {
    await _setupLocalDatabase();
  } else {
    debugPrint('Executando na web. Banco local não utilizado.');
  }

  runApp(const MyApp());
}

Future<void> _setupLocalDatabase() async {
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
}

Future<void> _criarUsuarioPadrao(UserDB userDB) async {
  final user = LocalUserModel.defaultUser();
  await userDB.insertUser(user);
  debugPrint('Usuário padrão criado.');
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
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      home: const StartScreen(),
    );
  }
}
