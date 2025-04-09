import 'package:flutter/material.dart';
import 'graphic_test.dart';
import 'utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Utils.buildHeader('Home'),
      body: Center(
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
              marginTop: 10
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
                    ), // Borda laranja
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Bordas arredondadas
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        "R\$ 2.000,00", // Valor de entrada
                        style: TextStyle(
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
                    ), // Borda laranja
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Bordas arredondadas
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.red),
                      const SizedBox(width: 5),
                      Text(
                        "R\$ 1.200,00", // Valor de saída
                        style: TextStyle(
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
            const PieChartGanhoDespesa(),
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
                ), // Borda laranja
                borderRadius: BorderRadius.circular(8), // Bordas arredondadas
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_upward, color: Colors.red),
                  const SizedBox(width: 5),
                  Text(
                    "R\$ 1.500,00", // Valor de saída
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
    );
  }
}
