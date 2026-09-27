import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Hive.init('./test/.hive_temp_widget');
    await ExpenseDatabase.instance.closeForTests();
    await ExpenseDatabase.instance.useTestBox();
    // Skip sample seeding so the home list stays predictable in tests.
    SharedPreferences.setMockInitialValues({'sample_data_seeded': true});
  });

  tearDown(() async {
    await ExpenseDatabase.instance.closeForTests();
  });

  testWidgets('App loads with bottom navigation tabs', (tester) async {
    await tester.pumpWidget(const SmartExpenseTrackerApp());
    // Wait for async DB init without pumpAndSettle (nav bar animations never settle).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Smart Expense Tracker'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Budget'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
  });
}
