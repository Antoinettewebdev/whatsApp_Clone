import 'package:flutter/material.dart';

import 'package:provider/provider.dart';



import '../models/expense.dart';

import '../providers/theme_provider.dart';

import 'add_expense_screen.dart';

import 'budget_screen.dart';

import 'home_screen.dart';

import 'reports_screen.dart';



/// Bottom navigation shell: Home, Add Expense, Budget, and Reports.

class MainShell extends StatefulWidget {

  const MainShell({super.key});



  @override

  State<MainShell> createState() => _MainShellState();

}



class _MainShellState extends State<MainShell> {

  int _currentIndex = 0;



  /// When the user taps Edit on Home, we switch to Add tab with this expense.

  Expense? _expenseToEdit;



  void _goToAddTab({Expense? expense}) {

    setState(() {

      _expenseToEdit = expense;

      _currentIndex = 1;

    });

  }



  /// After saving: return to Home only when editing; stay on Add when creating new.

  void _onExpenseSaved({required bool wasEdit}) {

    setState(() {

      _expenseToEdit = null;

      if (wasEdit) _currentIndex = 0;

    });

  }



  @override

  Widget build(BuildContext context) {

    final pages = [

      HomeScreen(onEditExpense: (expense) => _goToAddTab(expense: expense)),

      AddExpenseScreen(

        expenseToEdit: _expenseToEdit,

        onSaved: _onExpenseSaved,

      ),

      const BudgetScreen(),

      const ReportsScreen(),

    ];



    return Scaffold(

      body: IndexedStack(

        index: _currentIndex,

        children: pages,

      ),

      bottomNavigationBar: NavigationBar(

        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {

          setState(() {

            if (index != 1) _expenseToEdit = null;

            _currentIndex = index;

          });

        },

        destinations: const [

          NavigationDestination(

            icon: Icon(Icons.home_outlined),

            selectedIcon: Icon(Icons.home_rounded),

            label: 'Home',

          ),

          NavigationDestination(

            icon: Icon(Icons.add_circle_outline),

            selectedIcon: Icon(Icons.add_circle_rounded),

            label: 'Add',

          ),

          NavigationDestination(

            icon: Icon(Icons.savings_outlined),

            selectedIcon: Icon(Icons.savings_rounded),

            label: 'Budget',

          ),

          NavigationDestination(

            icon: Icon(Icons.bar_chart_outlined),

            selectedIcon: Icon(Icons.bar_chart_rounded),

            label: 'Reports',

          ),

        ],

      ),

      appBar: AppBar(

        title: Text(_titleForIndex(_currentIndex)),

        actions: [

          IconButton(

            tooltip: 'Toggle light / dark / system theme',

            onPressed: () => _cycleTheme(context),

            icon: const Icon(Icons.brightness_6_outlined),

          ),

        ],

      ),

    );

  }



  String _titleForIndex(int index) {

    switch (index) {

      case 0:

        return 'Smart Expense Tracker';

      case 1:

        return _expenseToEdit != null ? 'Edit Expense' : 'Add Expense';

      case 2:

        return 'Monthly Budget';

      default:

        return 'Reports & Dashboard';

    }

  }



  Future<void> _cycleTheme(BuildContext context) async {

    final provider = context.read<ThemeProvider>();

    final next = switch (provider.themeMode) {

      ThemeMode.light => ThemeMode.dark,

      ThemeMode.dark => ThemeMode.system,

      ThemeMode.system => ThemeMode.light,

    };

    await provider.setThemeMode(next);

  }

}


