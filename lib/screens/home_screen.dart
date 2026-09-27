import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_list_item.dart';

/// Home tab — shows every expense with edit and delete actions.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onEditExpense});

  /// Called when the user chooses Edit; parent switches to the Add tab.
  final void Function(Expense expense) onEditExpense;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Could not load expenses',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: provider.initialize,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        final expenses = provider.expenses;
        final currency = NumberFormat.currency(symbol: '\$');
        final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

        return Column(
          children: [
            // Quick summary banner at the top of the list
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All expenses',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.9),
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currency.format(total),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${expenses.length} item${expenses.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.85),
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: expenses.isEmpty
                  ? const EmptyState(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'No expenses yet',
                      subtitle:
                          'Use the Add Expense tab to record your first one',
                    )
                  : RefreshIndicator(
                      onRefresh: provider.initialize,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return ExpenseListItem(
                            expense: expense,
                            onEdit: () => onEditExpense(expense),
                            onDelete: () =>
                                _confirmDelete(context, provider, expense),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ExpenseProvider provider,
    Expense expense,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('Remove "${expense.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await provider.deleteExpense(expense.id!);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense deleted')),
    );
  }
}
