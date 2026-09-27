import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Hive.init('./test/.hive_temp');
    await ExpenseDatabase.instance.closeForTests();
    await ExpenseDatabase.instance.useTestBox();
  });

  tearDown(() async {
    await ExpenseDatabase.instance.closeForTests();
  });

  test('Expense round-trips through the database', () async {
    final db = ExpenseDatabase.instance;

    final expense = Expense(
      name: 'Coffee',
      amount: 4.5,
      date: DateTime(2026, 5, 18),
      category: 'Food',
    );

    final id = await db.insertExpense(expense);
    final all = await db.getAllExpenses();

    expect(all.length, 1);
    expect(all.first.id, id);
    expect(all.first.name, 'Coffee');
    expect(all.first.amount, 4.5);
    expect(all.first.category, 'Food');
  });

  test('Expense.fromMap parses stored rows', () {
    final expense = Expense.fromMap({
      'id': 1,
      'name': 'Bus fare',
      'amount': 3.25,
      'date': '2026-05-18T10:00:00.000',
      'category': 'Travel',
    });

    expect(expense.id, 1);
    expect(expense.name, 'Bus fare');
    expect(expense.amount, 3.25);
    expect(expense.category, 'Travel');
  });
}
