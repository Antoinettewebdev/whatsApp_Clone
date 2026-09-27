import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../providers/expense_provider.dart';
import '../utils/budget_calculator.dart';
import '../widgets/budget_circular_progress.dart';
import '../widgets/budget_editor_dialog.dart';
import '../widgets/budget_progress_bar.dart';

/// Budget tab — monthly limit, spending progress, and update button.
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  /// Opens the dialog and saves the new budget when the user confirms.
  Future<void> _openBudgetEditor(BuildContext context) async {
    final budgetProvider = context.read<BudgetProvider>();
    final amount = await showBudgetEditorDialog(
      context,
      currentBudget: budgetProvider.monthlyBudget,
    );

    if (amount == null || !context.mounted) return;

    await budgetProvider.setMonthlyBudget(amount);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Monthly budget saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ExpenseProvider, BudgetProvider>(
      builder: (context, expenses, budget, _) {
        if (budget.isLoading || expenses.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final currency = NumberFormat.currency(symbol: '\$');
        final monthName = DateFormat.yMMMM().format(DateTime.now());
        final spent = expenses.monthTotal;

        // No budget set yet — prompt the user to create one.
        if (!budget.hasBudget) {
          return _NoBudgetView(
            monthName: monthName,
            spent: spent,
            currency: currency,
            onSetBudget: () => _openBudgetEditor(context),
          );
        }

        final summary = BudgetSummary(
          budget: budget.monthlyBudget!,
          spent: spent,
        );

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              monthName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Monthly budget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // Large budget amount card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your budget',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Text(
                            currency.format(summary.budget),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Circular + horizontal progress
            Center(
              child: BudgetCircularProgress(
                usageFraction: summary.usageFraction,
                isOverBudget: summary.isOverBudget,
                percentLabel:
                    '${summary.usagePercent.clamp(0, 999).toStringAsFixed(0)}%',
              ),
            ),
            const SizedBox(height: 24),
            BudgetProgressBar(
              usageFraction: summary.usageFraction,
              isOverBudget: summary.isOverBudget,
            ),
            const SizedBox(height: 24),

            // Spent vs remaining row
            Row(
              children: [
                Expanded(
                  child: _AmountTile(
                    label: 'Spent this month',
                    amount: currency.format(summary.spent),
                    icon: Icons.shopping_cart_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AmountTile(
                    label: 'Remaining',
                    amount: currency.format(summary.remaining),
                    icon: Icons.savings_outlined,
                    color: summary.isOverBudget
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),

            // Red warning when over budget
            if (summary.isOverBudget) ...[
              const SizedBox(height: 20),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You are over budget by '
                          '${currency.format(-summary.remaining)}!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => _openBudgetEditor(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Update budget'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Shown when the user has not set a monthly budget yet.
class _NoBudgetView extends StatelessWidget {
  const _NoBudgetView({
    required this.monthName,
    required this.spent,
    required this.currency,
    required this.onSetBudget,
  });

  final String monthName;
  final double spent;
  final NumberFormat currency;
  final VoidCallback onSetBudget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No monthly budget yet',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Set a budget for $monthName to track your spending.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            if (spent > 0) ...[
              const SizedBox(height: 12),
              Text(
                'Spent so far: ${currency.format(spent)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onSetBudget,
              icon: const Icon(Icons.add),
              label: const Text('Set monthly budget'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String label;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
