import 'package:flutter/material.dart';

import 'summary_card.dart';

/// Groups Today / Week / Month totals inside one colored panel on the Reports tab.
class DashboardOverviewPanel extends StatelessWidget {
  const DashboardOverviewPanel({
    super.key,
    required this.todayTotal,
    required this.weekTotal,
    required this.monthTotal,
  });

  final double todayTotal;
  final double weekTotal;
  final double monthTotal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, scheme.tertiary, 0.55)!,
            scheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_rounded,
                color: scheme.onPrimary.withValues(alpha: 0.9),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 118,
            child: Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    label: 'Today',
                    amount: todayTotal,
                    icon: Icons.today_outlined,
                    color: scheme.onPrimary,
                    embedded: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SummaryCard(
                    label: 'This week',
                    amount: weekTotal,
                    icon: Icons.date_range_outlined,
                    color: scheme.onPrimary,
                    embedded: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SummaryCard(
                    label: 'This month',
                    amount: monthTotal,
                    icon: Icons.calendar_month_outlined,
                    color: scheme.onPrimary,
                    embedded: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
