import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../utils/category_helper.dart';

/// One row in the expense list with edit and delete actions.
class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat.MMMd();
    final categoryColor = CategoryHelper.colorFor(expense.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: categoryColor.withValues(alpha: 0.15),
          child: Icon(
            CategoryHelper.iconFor(expense.category),
            color: categoryColor,
          ),
        ),
        title: Text(
          expense.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${expense.category} · ${dateFormat.format(expense.date)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currency.format(expense.amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
