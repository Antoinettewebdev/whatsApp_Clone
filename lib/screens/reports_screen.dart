import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/dashboard_overview_panel.dart';
import '../widgets/spending_bar_chart.dart';

/// Reports tab — dashboard totals, pie chart, and spending trends.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  /// Toggle between weekly (7 days) and monthly (6 months) bar chart.
  bool _showWeeklyTrend = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final scheme = Theme.of(context).colorScheme;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quick overview of your spending',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.outline,
                  ),
            ),
            const SizedBox(height: 16),

            DashboardOverviewPanel(
              todayTotal: provider.todayTotal,
              weekTotal: provider.weekTotal,
              monthTotal: provider.monthTotal,
            ),
            const SizedBox(height: 24),

            _sectionTitle(context, 'Spending by category'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CategoryPieChart(
                  categoryTotals: provider.categoryTotals,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _sectionTitle(
                    context,
                    _showWeeklyTrend ? 'Weekly trend' : 'Monthly trend',
                  ),
                ),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Week')),
                    ButtonSegment(value: false, label: Text('Month')),
                  ],
                  selected: {_showWeeklyTrend},
                  onSelectionChanged: (selected) {
                    setState(() => _showWeeklyTrend = selected.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SpendingBarChart(
                  data: _showWeeklyTrend
                      ? provider.weeklyTrend
                      : provider.monthlyTrend,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
