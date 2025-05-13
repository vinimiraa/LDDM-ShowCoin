import 'package:flutter/material.dart';
import 'package:src/screens/start_screen.dart';
import 'package:src/screens/utils.dart';
import 'package:src/database/db.dart';
import 'package:sqflite/sqflite.dart';
import 'controllers/transaction_controller.dart';
import 'package:intl/intl.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
final transactionController = TransactionController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await DatabaseHelper().database;
  print('Banco de dados inicializado com sucesso!');
  final dbPath = await getDatabasesPath();
  print('Caminho do banco de dados: $dbPath');

  runApp(const MyApp());
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
