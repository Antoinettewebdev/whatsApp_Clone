import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense.dart';

/// Local expense storage using Hive (works on Android, iOS, desktop, and web).
///
/// Each expense is stored as a Map keyed by its integer [Expense.id].
class ExpenseDatabase {
  ExpenseDatabase._();
  static final ExpenseDatabase instance = ExpenseDatabase._();

  static const _boxName = 'expenses';
  Box<dynamic>? _box;

  /// Opens the Hive box. Call from [main] via [Hive.initFlutter] first.
  Future<void> init() async {
    await _openBox();
  }

  Future<Box<dynamic>> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox(_boxName);
    return _box!;
  }

  /// In-memory-style isolated box for unit tests.
  Future<void> useTestBox() async {
    if (_box?.isOpen == true) {
      await _box!.close();
    }
    _box = await Hive.openBox('${_boxName}_test');
    await _box!.clear();
  }

  Future<void> closeForTests() async {
    if (_box?.isOpen == true) {
      await _box!.close();
      _box = null;
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    final box = await _openBox();
    final expenses = <Expense>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        expenses.add(
          Expense.fromMap(Map<String, dynamic>.from(raw)),
        );
      }
    }

    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  Future<int> insertExpense(Expense expense) async {
    final box = await _openBox();
    final id = expense.id ?? _nextId(box);
    await box.put(id, expense.copyWith(id: id).toMap());
    return id;
  }

  Future<int> updateExpense(Expense expense) async {
    final box = await _openBox();
    await box.put(expense.id, expense.toMap());
    return expense.id!;
  }

  Future<int> deleteExpense(int id) async {
    final box = await _openBox();
    if (!box.containsKey(id)) return 0;
    await box.delete(id);
    return 1;
  }

  Future<int> countExpenses() async {
    final box = await _openBox();
    return box.length;
  }

  Future<void> insertSampleExpenses(List<Expense> expenses) async {
    final box = await _openBox();
    var nextId = _nextId(box);
    for (final expense in expenses) {
      await box.put(nextId, expense.copyWith(id: nextId).toMap());
      nextId++;
    }
  }

  int _nextId(Box<dynamic> box) {
    if (box.isEmpty) return 1;
    final ids = box.keys.whereType<int>();
    if (ids.isEmpty) return box.length + 1;
    return ids.reduce((a, b) => a > b ? a : b) + 1;
  }
}
