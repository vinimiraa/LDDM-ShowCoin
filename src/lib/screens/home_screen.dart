import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'graphic_test.dart';
import 'utils.dart';
import '../database/db.dart';
import 'transaction_details_screen.dart';
import '../main.dart'; // Importa o RouteObserver

class HomeScreen extends StatefulWidget {
  final VoidCallback? onFocus;

  const HomeScreen({super.key, this.onFocus}); // Aceita o parâmetro onFocus

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  double totalGanho = 0;
  double totalDespesa = 0;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.onFocus?.call(); // Chama o callback sempre que a tela se torna visível
    carregarValores();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Recarrega dados sempre que voltar para esta tela
    carregarValores();
  }

  // Função para carregar os valores do banco de dados
  Future<void> carregarValores() async {
    final db = await DatabaseHelper().database;
    final result = await db.rawQuery(''' 
      SELECT i.valor, i.nome 
      FROM Item i
      JOIN Possui p ON p.item_id = i.id
      JOIN Compra c ON c.id = p.compra_id
    ''');

    double ganho = 0;
    double despesa = 0;

    for (var row in result) {
      final valor = row['valor'] is int
          ? (row['valor'] as int).toDouble()
          : row['valor'] as double;
      final nome = (row['nome'] as String).toLowerCase();

      if (valor < 0) {
        despesa += valor.abs();
      } else {
        ganho += valor;
      }
    }

    setState(() {
      totalGanho = ganho;
      totalDespesa = despesa;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Utils.buildHeader('Home'),
      body: RefreshIndicator(
        onRefresh: carregarValores, // A função de atualização será chamada ao arrastar
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Exibe o carregamento
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Utils.buildText(
                      "Ganhos e Despesas",
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      marginBottom: 10,
                      marginTop: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.orange,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_downward, color: Colors.green),
                              const SizedBox(width: 5),
                              Text(
                                "R\$ ${totalGanho.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.orange,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_upward, color: Colors.red),
                              const SizedBox(width: 5),
                              Text(
                                "R\$ ${totalDespesa.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    PieChartGanhoDespesa(
                      totalGanho: totalGanho,
                      totalDespesa: totalDespesa,
                    ),
                    Utils.buildText(
                      "Meta de Gastos desse Mês",
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      marginBottom: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 180,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_upward, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            "R\$ 1.500,00",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionDetailsScreen(isNewTransaction: true),
            ),
          );

          if (result == true) {
            carregarValores(); // Atualiza os gráficos após uma nova transação
            transactionController.loadTransactions(); // Notifica StatementScreen
          }
        },
        backgroundColor: AppColors.backgroundButton,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
