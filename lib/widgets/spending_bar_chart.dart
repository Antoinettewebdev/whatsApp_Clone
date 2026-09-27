import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Bar chart for weekly (7 days) or monthly (6 months) spending trends.
class SpendingBarChart extends StatelessWidget {
  const SpendingBarChart({
    super.key,
    required this.data,
  });

  /// Map of label (e.g. "Mon" or "Jan") -> total amount for that period.
  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No trend data yet')),
      );
    }

    final labels = data.keys.toList();
    final values = data.values.toList();
    final maxY = values.fold(0.0, (a, b) => a > b ? a : b);
    final chartMaxY = maxY <= 0 ? 10.0 : maxY * 1.2;

    final scheme = Theme.of(context).colorScheme;
    final currency = NumberFormat.compactCurrency(symbol: '\$');

    return SizedBox(
      height: 240,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: chartMaxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: chartMaxY / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: scheme.outlineVariant.withValues(alpha: 0.4),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value > chartMaxY) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    currency.format(value),
                    style: TextStyle(
                      fontSize: 10,
                      color: scheme.outline,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(labels.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  color: scheme.primary,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
