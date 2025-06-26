import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class PieChartGastos extends StatefulWidget {
  final double limiteGasto;
  final double totalGasto;

  const PieChartGastos({
    super.key,
    required this.limiteGasto,
    required this.totalGasto,
  });

  @override
  State<StatefulWidget> createState() => PieChartGanhoDespesaState();
}

class PieChartGanhoDespesaState extends State<PieChartGastos> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Column(
        children: [
          const SizedBox(height: 24),
          if (widget.totalGasto > widget.limiteGasto)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.warning, color: AppColors.contentColorRed, size: 24),
                SizedBox(width: 6),
                Text(
                  'Limite ultrapassado',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.contentColorRed,
                  ),
                ),
              ],
            ),

          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Indicator(
                color: GraphicColors.contentColorGreen,
                text: 'Limite Restante',
                isSquare: true,
              ),
              SizedBox(width: 20),
              Indicator(
                color: GraphicColors.contentColorRed,
                text: 'Despesas',
                isSquare: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final isLimiteRestanteTouched = touchedIndex == 0;
    final isDespesaTouched = touchedIndex == 1;

    final limiteFontSize = isLimiteRestanteTouched ? 25.0 : 16.0;
    final limiteRadius = isLimiteRestanteTouched ? 60.0 : 50.0;

    final despesaFontSize = isDespesaTouched ? 25.0 : 16.0;
    final despesaRadius = isDespesaTouched ? 60.0 : 50.0;

    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    double limiteRestante = (widget.limiteGasto - widget.totalGasto).clamp(
      0,
      widget.limiteGasto,
    );
    double despesa = widget.totalGasto;

    double total = limiteRestante + despesa;
    double limitePercent = total > 0 ? (limiteRestante / total) * 100 : 0;
    double despesaPercent = total > 0 ? (despesa / total) * 100 : 0;

    return [
      PieChartSectionData(
        color: GraphicColors.contentColorGreen,
        value: limitePercent,
        title: '${limitePercent.toStringAsFixed(1)}%',
        radius: limiteRadius,
        titleStyle: TextStyle(
          fontSize: limiteFontSize,
          fontWeight: FontWeight.bold,
          color: GraphicColors.mainTextColor1,
          shadows: shadows,
        ),
      ),
      PieChartSectionData(
        color: GraphicColors.contentColorRed,
        value: despesaPercent,
        title: '${despesaPercent.toStringAsFixed(1)}%',
        radius: despesaRadius,
        titleStyle: TextStyle(
          fontSize: despesaFontSize,
          fontWeight: FontWeight.bold,
          color: GraphicColors.mainTextColor1,
          shadows: shadows,
        ),
      ),
    ];
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class GraphicColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF28812E);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
