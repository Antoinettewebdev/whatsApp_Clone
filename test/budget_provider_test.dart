import 'package:expense_tracker/providers/budget_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('BudgetProvider loads and saves monthly budget', () async {
    final provider = BudgetProvider();
    await provider.initialize();

    expect(provider.hasBudget, false);

    await provider.setMonthlyBudget(1000);
    expect(provider.monthlyBudget, 1000);
    expect(provider.hasBudget, true);

    // Simulate app restart — new provider instance should load saved value.
    final reloaded = BudgetProvider();
    await reloaded.initialize();
    expect(reloaded.monthlyBudget, 1000);
  });
}
