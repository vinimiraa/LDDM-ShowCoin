import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'graphic_test.dart';
import 'utils.dart';
import '../database/db.dart';
import 'transaction_details_screen.dart';
import '../main.dart'; // Importa o RouteObserver

class HomeScreen extends StatefulWidget {
  final PersistentTabController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with RouteAware, WidgetsBindingObserver {
  double limiteGasto = 0;
  double totalGasto = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_handleTabChange);

    carregarValores();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.controller.index == 0) {
      carregarValores();
    }
  }

Future<void> carregarValores() async {
  final db = await DatabaseHelper().database;

  // Buscar limite de gastos do usuário (supondo que id=1)
  final usuarioResult = await db.query(
    'UsuarioLocal',
    columns: ['limite_gastos'],
    where: 'id = ?',
    whereArgs: [1],
    limit: 1,
  );

  double limite = 0;
  if (usuarioResult.isNotEmpty) {
    final lim = usuarioResult.first['limite_gastos'];
    if (lim is int) {
      limite = lim.toDouble();
    } else if (lim is double) {
      limite = lim;
    }
  }

  // Buscar todas as transações para calcular o total gasto
  final result = await db.rawQuery('SELECT valor FROM Transacao');

  double despesa = 0;
  for (var row in result) {
    final valor = row['valor'] is int
        ? (row['valor'] as int).toDouble()
        : row['valor'] as double;

    despesa += valor.abs(); // Considera todas como despesas
  }

  setState(() {
    limiteGasto = limite;
    totalGasto = despesa;
    isLoading = false;
  });
}
Future<void> atualizarLimiteNoBanco(double novoLimite) async {
  final db = await DatabaseHelper().database;

  await db.update(
    'UsuarioLocal',
    {'limite_gastos': novoLimite},
    where: 'id = ?',
    whereArgs: [1],  // Assumindo que o usuário tem id = 1
  );
  debugPrint("LIMITE ATUALIZADO: $novoLimite");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Utils.buildHeader('Home'),
      body: Container(
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(),
                ) // Exibe o carregamento
                : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Utils.buildText(
                        "Gastos e Limites",
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        marginBottom: 10,
                        marginTop: 10,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final newLimit = await showDialog<double>(
                                context: context,
                                builder: (context) {
                                  double tempLimit = limiteGasto;
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Editar Limite de Gasto',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          TextField(
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Novo Limite',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              tempLimit =
                                                  double.tryParse(value) ??
                                                  limiteGasto;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors
                                                            .contentColorRed,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop(tempLimit);
                                                  },
                                                  child: Text(
                                                    "Cancelar",
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.background,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 120,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors
                                                            .contentColorGreen,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop(tempLimit);
                                                  },
                                                  child: Text(
                                                    "Salvar",
                                                    style: const TextStyle(
                                                      color: Color(0xFFFFFFFF),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (newLimit != null && newLimit != limiteGasto) {
                                await atualizarLimiteNoBanco(newLimit); // Persiste o novo limite no banco
                                      setState(() {
                                        limiteGasto = newLimit; // Atualiza o estado local
                                      });
                                await carregarValores();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 20,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                ),
                                Text(
                                  "Limite de Gasto",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.contentColorGreen,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 5),
                                      Text(
                                        "R\$ ${limiteGasto.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: AppColors.contentColorGreen,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.edit,
                                  color: AppColors.contentColorGreen,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Padding(padding: const EdgeInsets.only(left: 15)),
                              Text(
                                "Total de Gastos",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.contentColorRed,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    Text(
                                      "R\$ ${totalGasto.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: AppColors.contentColorRed,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Text(
                                  "Limite restante",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.contentColorOrange,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    Text(
                                      "R\$ ${(limiteGasto - totalGasto).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: AppColors.contentColorOrange,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      PieChartGanhoDespesa(
                        limiteGasto: limiteGasto,
                        totalGasto: totalGasto,
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
            await carregarValores(); // Atualiza gráficos e valores depois de inserir
            transactionController.loadTransactions(); // Atualiza tela de extrato
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
