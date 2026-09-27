import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/date_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Monday of a fixed week — use Wed + Mon so both fall in the same ISO week.
  final now = DateTime(2026, 5, 11);

  final expenses = [
    Expense(name: 'Monday', amount: 10, date: now, category: 'Food'),
    Expense(
      name: 'Wednesday',
      amount: 20,
      date: DateTime(2026, 5, 13),
      category: 'Travel',
    ),
    Expense(
      name: 'Last month',
      amount: 30,
      date: DateTime(2026, 4, 1),
      category: 'Bills',
    ),
  ];

  test('today, week, and month filters sum correctly', () {
    expect(
      DateFilters.sumWhere(expenses, (e) => DateFilters.isSameDay(e.date, now)),
      10,
    );
    expect(
      DateFilters.sumWhere(expenses, (e) => DateFilters.isSameWeek(e.date, now)),
      30,
    );
    expect(
      DateFilters.sumWhere(
        expenses,
        (e) => DateFilters.isSameMonth(e.date, now),
      ),
      30,
    );
  });

  test('category totals group amounts', () {
    final totals = DateFilters.totalsByCategory(expenses);
    expect(totals['Food'], 10);
    expect(totals['Travel'], 20);
    expect(totals['Bills'], 30);
  });
}
