import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gsl/app/utils/color_extensions.dart';

import 'appColors.dart';

class BarChartSample3 extends StatefulWidget {
  final List<int> transactionsPerDay;

  const BarChartSample3({Key? key, required this.transactionsPerDay}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  List<int> transactionsPerDay = []; // Tambahkan variabel transactionsPerDay

  @override
  void initState() {
    super.initState();
    transactionsPerDay = widget
        .transactionsPerDay; // Inisialisasi transactionsPerDay dengan data dari widget induk
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: _createBarGroups(widget.transactionsPerDay),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceEvenly,
          maxY: 15,
          backgroundColor: const Color(0xFF2d4261),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white, // You can customize the tooltip text color here
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: _getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue, // Customize the gradient colors here
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> _createBarGroups(List<int> transactionsPerDay) {
    return transactionsPerDay.asMap().entries.map((entry) {
      final dayIndex = entry.key;
      final transactionCount = entry.value;

      return BarChartGroupData(
        x: dayIndex,
        barRods: [
          BarChartRodData(
            toY: transactionCount.toDouble(),
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  Widget _getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.contentColorBlue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    final List<String> dayNames = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

    final int intValue = value.toInt();

    // Menggunakan modulo untuk looping nama hari
    final String dayName = dayNames[(intValue - 1) % dayNames.length];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(dayName, style: style),
    );
  }
}
