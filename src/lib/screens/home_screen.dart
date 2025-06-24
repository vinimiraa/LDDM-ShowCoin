// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'transaction_details_screen.dart';
import '../database/user_db.dart';
// import '../main.dart';
import '../screens/graphic_test.dart';
import '../screens/utils.dart';
import '../controllers/transaction_controller.dart';

class HomeScreen extends StatefulWidget {
  final PersistentTabController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  double limiteGasto = 0;
  double totalGasto = 0;
  bool isLoading = true;

  final userDB = UserDB();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTabChange);
    carregarValores();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.controller.index == 0) {
      carregarValores();
    }
  }

  Future<void> carregarValores() async {
    setState(() => isLoading = true);

    final user = await userDB.getFirstUser();
    final transactions = transactionController.transactions;

    double total = 0;
    for (var t in transactions) {
      total += (t['value'] as num).abs();
    }

    setState(() {
      limiteGasto = user?.spendingLimit ?? 0;
      totalGasto = total;
      isLoading = false;
    });
  }

  Future<void> atualizarLimite(double novoLimite) async {
    final user = await userDB.getFirstUser();
    if (user != null) {
      await userDB.updateUser(user.copyWith(spendingLimit: novoLimite));
      setState(() => limiteGasto = novoLimite);
      await carregarValores();
    }
  }

  Future<void> abrirDialogoEditarLimite() async {
    double tempLimit = limiteGasto;
    final newLimit = await showDialog<double>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  tempLimit = double.tryParse(value) ?? limiteGasto;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialogButton(
                    label: "Cancelar",
                    color: AppColors.contentColorRed,
                    onTap: () => Navigator.pop(context, null),
                  ),
                  _buildDialogButton(
                    label: "Salvar",
                    color: AppColors.contentColorGreen,
                    onTap: () => Navigator.pop(context, tempLimit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (newLimit != null && newLimit != limiteGasto) {
      await atualizarLimite(newLimit);
    }
  }

  Widget _buildDialogButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 120,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.background,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required Color borderColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (onTap != null)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.edit, color: AppColors.contentColorGreen, size: 18),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Utils.buildHeader('Home'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Utils.buildText(
                    "Gastos e Limites",
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    marginBottom: 10,
                    marginTop: 10,
                  ),
                  _buildInfoRow(
                    label: "Limite de Gasto",
                    value: "R\$ ${limiteGasto.toStringAsFixed(2)}",
                    borderColor: AppColors.contentColorGreen,
                    textColor: AppColors.contentColorGreen,
                    onTap: abrirDialogoEditarLimite,
                  ),
                  _buildInfoRow(
                    label: "Total de Gastos",
                    value: "R\$ ${totalGasto.toStringAsFixed(2)}",
                    borderColor: AppColors.contentColorRed,
                    textColor: AppColors.contentColorRed,
                  ),
                  _buildInfoRow(
                    label: "Limite Restante",
                    value: "R\$ ${(limiteGasto - totalGasto).toStringAsFixed(2)}",
                    borderColor: AppColors.contentColorOrange,
                    textColor: AppColors.contentColorOrange,
                  ),
                  PieChartGastos(
                    limiteGasto: limiteGasto,
                    totalGasto: totalGasto,
                  ),
                ],
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
            await carregarValores();
            await transactionController.loadTransactions();
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
