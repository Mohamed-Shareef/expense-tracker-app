// =============================================================================
// Add/Edit Expense Screen - Form for creating or editing expenses
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/category_chip.dart';

/// Screen for adding a new expense or editing an existing one
class AddExpenseScreen extends StatefulWidget {
  final Expense? expense; // null for new expense, existing expense for edit

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late Category _selectedCategory;
  late DateTime _selectedDate;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    // Check if we're editing an existing expense
    _isEditing = widget.expense != null;

    if (_isEditing) {
      // Populate fields with existing expense data
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toStringAsFixed(2);
      _noteController.text = widget.expense!.note ?? '';
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    } else {
      // Default values for new expense
      _selectedCategory = Category.other;
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Expense' : 'Add Expense'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.error,
              ),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount field
              _buildAmountField(theme),

              const SizedBox(height: AppConstants.paddingLarge),

              // Title field
              _buildTitleField(theme),

              const SizedBox(height: AppConstants.paddingLarge),

              // Category selection
              _buildCategorySection(theme),

              const SizedBox(height: AppConstants.paddingLarge),

              // Date picker
              _buildDatePicker(theme),

              const SizedBox(height: AppConstants.paddingLarge),

              // Note field
              _buildNoteField(theme),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Save button
              _buildSaveButton(theme),

              const SizedBox(height: AppConstants.paddingMedium),

              // Cancel button
              _buildCancelButton(theme),

              const SizedBox(height: AppConstants.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the amount input field with large styling
  Widget _buildAmountField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                '\$',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            hintText: '0.00',
            filled: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Builds the title input field
  Widget _buildTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        TextFormField(
          controller: _titleController,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'What did you spend on?',
            prefixIcon: Icon(Icons.edit_note_rounded),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Builds the category selection section
  Widget _buildCategorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        CategorySelectionGrid(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
        ),
      ],
    );
  }

  /// Builds the date picker section
  Widget _buildDatePicker(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: theme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Text(
                  formatDate(_selectedDate),
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the note input field
  Widget _buildNoteField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note (optional)',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        TextFormField(
          controller: _noteController,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Add any additional details...',
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Icon(Icons.notes_rounded),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the save button
  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveExpense,
        icon: Icon(_isEditing ? Icons.check_rounded : Icons.add_rounded),
        label: Text(_isEditing ? 'Save Changes' : 'Add Expense'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
        ),
      ),
    );
  }

  /// Builds the cancel button
  Widget _buildCancelButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }

  /// Opens the date picker
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Saves the expense
  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: _isEditing ? widget.expense!.id : generateId(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      final provider = context.read<ExpenseProvider>();

      if (_isEditing) {
        provider.updateExpense(widget.expense!.id, expense);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense updated')),
        );
      } else {
        provider.addExpense(expense);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added')),
        );
      }

      Navigator.pop(context);
    }
  }

  /// Shows delete confirmation dialog
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ExpenseProvider>().deleteExpense(widget.expense!.id);
                Navigator.pop(dialogContext);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense deleted')),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
