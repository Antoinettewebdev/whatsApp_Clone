import 'package:flutter/material.dart';

/// Horizontal progress bar showing how much of the monthly budget is used.
class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    super.key,
    required this.usageFraction,
    required this.isOverBudget,
  });

  /// Value from 0.0 (none used) upward; may exceed 1.0 when over budget.
  final double usageFraction;
  final bool isOverBudget;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Cap the bar at 100% width, but color turns red when over budget.
    final displayValue = usageFraction.clamp(0.0, 1.0);
    final barColor =
        isOverBudget ? scheme.error : scheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: displayValue,
            minHeight: 12,
            backgroundColor: scheme.surfaceContainerHighest,
            color: barColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.outline,
                  ),
            ),
            Text(
              '${(usageFraction * 100).clamp(0, 999).toStringAsFixed(0)}% used',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isOverBudget ? scheme.error : scheme.onSurface,
                  ),
            ),
            Text(
              '100%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.outline,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
