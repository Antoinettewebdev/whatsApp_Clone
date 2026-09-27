import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

/// Add Expense tab — create a new expense or edit an existing one.
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
    this.expenseToEdit,
    required this.onSaved,
  });

  final Expense? expenseToEdit;
  /// Called after a successful save. [wasEdit] tells the shell whether to switch tabs.
  final void Function({required bool wasEdit}) onSaved;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late DateTime _selectedDate;
  late String _selectedCategory;

  bool get _isEditing => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();
    _resetForm(widget.expenseToEdit);
  }

  @override
  void didUpdateWidget(AddExpenseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When Home sends an expense to edit, refresh the form fields in place.
    if (oldWidget.expenseToEdit?.id != widget.expenseToEdit?.id) {
      _applyExpenseToForm(widget.expenseToEdit);
    }
  }

  /// Sets up controllers on first build (called from initState only).
  void _resetForm(Expense? expense) {
    _nameController = TextEditingController(text: expense?.name ?? '');
    _amountController = TextEditingController(
      text: expense != null ? expense.amount.toStringAsFixed(2) : '',
    );
    _selectedDate = expense?.date ?? DateTime.now();
    _selectedCategory = expense?.category ?? Expense.categories.first;
  }

  /// Updates form fields without recreating controllers (safe in didUpdateWidget).
  void _applyExpenseToForm(Expense? expense) {
    _nameController.text = expense?.name ?? '';
    _amountController.text =
        expense != null ? expense.amount.toStringAsFixed(2) : '';
    setState(() {
      _selectedDate = expense?.date ?? DateTime.now();
      _selectedCategory = expense?.category ?? Expense.categories.first;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ExpenseProvider>();
    final amount = double.parse(_amountController.text.trim());

    final expense = Expense(
      id: widget.expenseToEdit?.id,
      name: _nameController.text.trim(),
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    if (_isEditing) {
      await provider.updateExpense(expense);
    } else {
      await provider.addExpense(expense);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Expense updated' : 'Expense added'),
      ),
    );

    // Clear form after adding (keep fields when editing until user leaves tab)
    if (!_isEditing) {
      _nameController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _selectedCategory = Expense.categories.first;
      });
    }

    widget.onSaved(wasEdit: _isEditing);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            _isEditing
                ? 'Update the fields below and save.'
                : 'Fill in the details for your expense.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Groceries',
              prefixIcon: Icon(Icons.receipt_long_outlined),
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: '0.00',
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: Expense.categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Date'),
              subtitle: Text(
                MaterialLocalizations.of(context)
                    .formatMediumDate(_selectedDate),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _submit,
            icon: Icon(_isEditing ? Icons.save_outlined : Icons.add),
            label: Text(_isEditing ? 'Save Changes' : 'Add Expense'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ],
      ),
    );
  }
}
