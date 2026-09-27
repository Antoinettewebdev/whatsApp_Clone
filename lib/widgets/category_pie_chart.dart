import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/category_helper.dart';

/// Pie chart showing how spending is split across categories.
class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
  });

  final Map<String, double> categoryTotals;

  @override
  Widget build(BuildContext context) {
    final entries = categoryTotals.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No spending data yet')),
      );
    }

    final total = entries.fold(0.0, (sum, e) => sum + e.value);
    final currency = NumberFormat.currency(symbol: '\$');

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 48,
              sections: entries.map((entry) {
                final percent = (entry.value / total * 100);
                final color = CategoryHelper.colorFor(entry.key);
                return PieChartSectionData(
                  value: entry.value,
                  title: '${percent.toStringAsFixed(0)}%',
                  color: color,
                  radius: 52,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: entries.map((entry) {
            final color = CategoryHelper.colorFor(entry.key);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text('${entry.key}: ${currency.format(entry.value)}'),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
