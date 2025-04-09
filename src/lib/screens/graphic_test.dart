import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartGanhoDespesa extends StatefulWidget {
  const PieChartGanhoDespesa({super.key});

  @override
  State<StatefulWidget> createState() => PieChartGanhoDespesaState();
}

class PieChartGanhoDespesaState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: GAppColors.contentColorGreen,
                text: 'Ganho',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: GAppColors.contentColorRed,
                text: 'Despesa',
                isSquare: true,
              ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final isGanhoTouched = touchedIndex == 0;
    final isDespesaTouched = touchedIndex == 1;

    final ganhoFontSize = isGanhoTouched ? 25.0 : 16.0;
    final ganhoRadius = isGanhoTouched ? 60.0 : 50.0;

    final despesaFontSize = isDespesaTouched ? 25.0 : 16.0;
    final despesaRadius = isDespesaTouched ? 60.0 : 50.0;

    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    return [
      PieChartSectionData(
        color: GAppColors.contentColorGreen,
        value: 60,
        title: '60%',
        radius: ganhoRadius,
        titleStyle: TextStyle(
          fontSize: ganhoFontSize,
          fontWeight: FontWeight.bold,
          color: GAppColors.mainTextColor1,
          shadows: shadows,
        ),
      ),
      PieChartSectionData(
        color: GAppColors.contentColorRed,
        value: 40,
        title: '40%',
        radius: despesaRadius,
        titleStyle: TextStyle(
          fontSize: despesaFontSize,
          fontWeight: FontWeight.bold,
          color: GAppColors.mainTextColor1,
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
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class GAppColors {
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
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}