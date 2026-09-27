/// Helper values for comparing monthly spending against a budget.
class BudgetSummary {
  const BudgetSummary({
    required this.budget,
    required this.spent,
  });

  final double budget;
  final double spent;

  /// Amount still available (negative when over budget).
  double get remaining => budget - spent;

  /// Fraction of budget used (0.0 to 1.0+). Used for progress bars.
  double get usageFraction => budget > 0 ? spent / budget : 0;

  /// Percentage for display (e.g. 75 for 75%).
  double get usagePercent => usageFraction * 100;

  /// True when spending has exceeded the monthly budget.
  bool get isOverBudget => spent > budget;
}
