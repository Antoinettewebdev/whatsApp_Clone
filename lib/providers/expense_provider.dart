import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/expense_database.dart';
import '../models/expense.dart';
import '../utils/date_filters.dart';
import '../utils/sample_data.dart';

/// Central state for expenses: loads from Hive and notifies UI on changes.
class ExpenseProvider extends ChangeNotifier {
  final ExpenseDatabase _db = ExpenseDatabase.instance;

  List<Expense> _expenses = [];
  bool _isLoading = true;
  String? _error;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Call once when the app starts.
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.init();
      await _seedSampleDataIfNeeded();
      _expenses = await _db.getAllExpenses();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inserts demo data only on the very first launch.
  Future<void> _seedSampleDataIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    const seedKey = 'sample_data_seeded';

    if (prefs.getBool(seedKey) == true) return;

    final count = await _db.countExpenses();
    if (count == 0) {
      await _db.insertSampleExpenses(buildSampleExpenses());
    }

    await prefs.setBool(seedKey, true);
  }

  Future<void> addExpense(Expense expense) async {
    final id = await _db.insertExpense(expense);
    _expenses = [
      expense.copyWith(id: id),
      ..._expenses,
    ];
    _sortExpenses();
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await _db.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index >= 0) {
      _expenses[index] = expense;
      _sortExpenses();
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    await _db.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void _sortExpenses() {
    _expenses.sort((a, b) => b.date.compareTo(a.date));
  }

  // --- Dashboard calculations (used by Reports screen) ---

  double get todayTotal {
    final now = DateTime.now();
    return DateFilters.sumWhere(
      _expenses,
      (e) => DateFilters.isSameDay(e.date, now),
    );
  }

  double get weekTotal {
    final now = DateTime.now();
    return DateFilters.sumWhere(
      _expenses,
      (e) => DateFilters.isSameWeek(e.date, now),
    );
  }

  double get monthTotal {
    final now = DateTime.now();
    return DateFilters.sumWhere(
      _expenses,
      (e) => DateFilters.isSameMonth(e.date, now),
    );
  }

  /// All-time totals per category (powers the pie chart on Reports).
  Map<String, double> get categoryTotals =>
      DateFilters.totalsByCategory(_expenses);

  Map<String, double> get weeklyTrend => DateFilters.weeklyTrend(_expenses);

  Map<String, double> get monthlyTrend => DateFilters.monthlyTrend(_expenses);
}
