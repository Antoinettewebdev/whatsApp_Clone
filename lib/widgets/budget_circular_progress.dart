import 'package:flutter/material.dart';

/// Circular chart in the center of the Budget screen showing usage percent.
class BudgetCircularProgress extends StatelessWidget {
  const BudgetCircularProgress({
    super.key,
    required this.usageFraction,
    required this.isOverBudget,
    required this.percentLabel,
  });

  final double usageFraction;
  final bool isOverBudget;
  final String percentLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progressColor =
        isOverBudget ? scheme.error : scheme.primary;
    final displayValue = usageFraction.clamp(0.0, 1.0);

    return SizedBox(
      height: 160,
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: CircularProgressIndicator(
              value: displayValue,
              strokeWidth: 12,
              backgroundColor: scheme.surfaceContainerHighest,
              color: progressColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                percentLabel,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isOverBudget ? scheme.error : scheme.onSurface,
                    ),
              ),
              Text(
                'of budget',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.outline,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
