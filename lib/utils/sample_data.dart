import '../models/expense.dart';

/// Sample expenses inserted on first launch so charts and lists are not empty.
List<Expense> buildSampleExpenses() {
  final now = DateTime.now();

  return [
    Expense(
      name: 'Grocery run',
      amount: 54.20,
      date: now,
      category: 'Food',
    ),
    Expense(
      name: 'Coffee shop',
      amount: 6.50,
      date: now,
      category: 'Food',
    ),
    Expense(
      name: 'Metro pass',
      amount: 35.00,
      date: now.subtract(const Duration(days: 1)),
      category: 'Travel',
    ),
    Expense(
      name: 'Online order',
      amount: 89.99,
      date: now.subtract(const Duration(days: 2)),
      category: 'Shopping',
    ),
    Expense(
      name: 'Electric bill',
      amount: 120.00,
      date: now.subtract(const Duration(days: 3)),
      category: 'Bills',
    ),
    Expense(
      name: 'Movie tickets',
      amount: 28.00,
      date: now.subtract(const Duration(days: 4)),
      category: 'Other',
    ),
    Expense(
      name: 'Restaurant',
      amount: 42.75,
      date: now.subtract(const Duration(days: 5)),
      category: 'Food',
    ),
    Expense(
      name: 'Flight booking',
      amount: 210.00,
      date: now.subtract(const Duration(days: 6)),
      category: 'Travel',
    ),
    Expense(
      name: 'Phone bill',
      amount: 65.00,
      date: now.subtract(const Duration(days: 10)),
      category: 'Bills',
    ),
    Expense(
      name: 'Clothing',
      amount: 75.50,
      date: now.subtract(const Duration(days: 14)),
      category: 'Shopping',
    ),
    Expense(
      name: 'Snacks',
      amount: 12.30,
      date: now.subtract(const Duration(days: 20)),
      category: 'Food',
    ),
    Expense(
      name: 'Gym membership',
      amount: 45.00,
      date: now.subtract(const Duration(days: 25)),
      category: 'Other',
    ),
  ];
}
