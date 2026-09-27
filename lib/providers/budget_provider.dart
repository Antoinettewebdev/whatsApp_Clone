import 'package:flutter/material.dart';

import '../services/budget_storage.dart';

/// Holds the user's monthly budget and notifies the UI when it changes.
///
/// Spending totals come from [ExpenseProvider.monthTotal]; this class only
/// stores the budget limit itself.
class BudgetProvider extends ChangeNotifier {
  final BudgetStorage _storage = BudgetStorage();

  double? _monthlyBudget;
  bool _isLoading = true;

  /// Saved budget amount (null if the user has not set one yet).
  double? get monthlyBudget => _monthlyBudget;

  bool get isLoading => _isLoading;

  /// True when a budget greater than zero has been saved.
  bool get hasBudget => _monthlyBudget != null && _monthlyBudget! > 0;

  /// Called once at app startup (see [main.dart]).
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _monthlyBudget = await _storage.loadBudget();

    _isLoading = false;
    notifyListeners();
  }

  /// Saves a new monthly budget (persists across app restarts).
  Future<void> setMonthlyBudget(double amount) async {
    await _storage.saveBudget(amount);
    _monthlyBudget = amount;
    notifyListeners();
  }
}
