import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dialog where the user enters or updates their monthly budget amount.
Future<double?> showBudgetEditorDialog(
  BuildContext context, {
  double? currentBudget,
}) {
  return showDialog<double>(
    context: context,
    builder: (context) => _BudgetEditorDialog(initialAmount: currentBudget),
  );
}

class _BudgetEditorDialog extends StatefulWidget {
  const _BudgetEditorDialog({this.initialAmount});

  final double? initialAmount;

  @override
  State<_BudgetEditorDialog> createState() => _BudgetEditorDialogState();
}

class _BudgetEditorDialogState extends State<_BudgetEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialAmount != null
          ? widget.initialAmount!.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.trim());
    Navigator.pop(context, amount);
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.initialAmount != null;

    return AlertDialog(
      title: Text(isUpdate ? 'Update monthly budget' : 'Set monthly budget'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Budget amount',
            hintText: 'e.g. 1000',
            prefixIcon: Icon(Icons.attach_money),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter a budget amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Enter a valid amount greater than 0';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(isUpdate ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}
