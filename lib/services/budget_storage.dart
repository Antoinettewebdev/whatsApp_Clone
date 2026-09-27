import 'package:shared_preferences/shared_preferences.dart';

/// Saves and loads the monthly budget using SharedPreferences.
///
/// SharedPreferences stores simple key–value pairs on the device so the
/// budget survives when the user closes the app.
class BudgetStorage {
  static const _budgetKey = 'monthly_budget_amount';

  /// Returns the saved budget, or `null` if the user has not set one yet.
  Future<double?> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble(_budgetKey);
    return value;
  }

  /// Persists the monthly budget amount (e.g. 1000.0 for $1000).
  Future<void> saveBudget(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, amount);
  }

  /// Removes the saved budget (optional helper for tests).
  Future<void> clearBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_budgetKey);
  }
}
