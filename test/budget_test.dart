import 'package:expense_tracker/utils/budget_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BudgetSummary calculates remaining and usage', () {
    const summary = BudgetSummary(budget: 1000, spent: 750);

    expect(summary.remaining, 250);
    expect(summary.usageFraction, 0.75);
    expect(summary.usagePercent, 75);
    expect(summary.isOverBudget, false);
  });

  test('BudgetSummary detects over budget', () {
    const summary = BudgetSummary(budget: 1000, spent: 1200);

    expect(summary.remaining, -200);
    expect(summary.isOverBudget, true);
    expect(summary.usageFraction, 1.2);
  });
}
