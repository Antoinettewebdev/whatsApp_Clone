import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'database/expense_database.dart';
import 'providers/budget_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

/// App entry point — initializes Hive, then runs Smart Expense Tracker.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await ExpenseDatabase.instance.init();
  runApp(const SmartExpenseTrackerApp());
}

/// Root widget: themes, state management, and the main navigation shell.
class SmartExpenseTrackerApp extends StatelessWidget {
  const SmartExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Smart Expense Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.themeMode,
            home: const MainShell(),
          );
        },
      ),
    );
  }
}
