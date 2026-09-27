import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Small card showing a spending total (today, week, or month).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.embedded = false,
  });

  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  /// When true, renders as a frosted tile inside [DashboardOverviewPanel].
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '\$');
    final scheme = Theme.of(context).colorScheme;

    final labelColor =
        embedded ? color.withValues(alpha: 0.85) : scheme.outline;
    final amountColor = embedded ? color : scheme.onSurface;

    final content = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: embedded ? 24 : 28),
          const Spacer(),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: labelColor,
                ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              currency.format(amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
            ),
          ),
        ],
      ),
    );

    if (embedded) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.onPrimary.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.22),
          ),
        ),
        child: content,
      );
    }

    return Card(child: content);
  }
}
