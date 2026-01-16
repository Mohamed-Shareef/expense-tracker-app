// =============================================================================
// Expenses Screen - All expenses list with filters and search
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/expense_card.dart';
import '../widgets/category_chip.dart';
import 'add_expense_screen.dart';

/// Screen displaying all expenses with filtering and search functionality
class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _showSearch ? _buildSearchField() : const Text('All Expenses'),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  context.read<ExpenseProvider>().setSearchQuery('');
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter row
          _buildCategoryFilter(),

          const SizedBox(height: AppConstants.paddingSmall),

          // Expenses list
          Expanded(
            child: _buildExpensesList(),
          ),

          // Total footer
          _buildTotalFooter(theme),
        ],
      ),
    );
  }

  /// Builds the search text field
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search expenses...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (value) {
        context.read<ExpenseProvider>().setSearchQuery(value);
      },
    );
  }

  /// Builds the category filter row
  Widget _buildCategoryFilter() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: AppConstants.paddingSmall),
          child: CategoryFilterRow(
            selectedCategory: provider.selectedCategory,
            onCategorySelected: (category) {
              provider.setSelectedCategory(category);
            },
          ),
        );
      },
    );
  }

  /// Builds the expenses list
  Widget _buildExpensesList() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final expenses = provider.filteredExpenses;

        if (expenses.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            top: AppConstants.paddingSmall,
            bottom: AppConstants.paddingLarge,
          ),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ExpenseCard(
              expense: expense,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddExpenseScreen(expense: expense),
                  ),
                );
              },
              onLongPress: () {
                _showExpenseOptions(context, expense);
              },
            );
          },
        );
      },
    );
  }

  /// Builds empty state widget
  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'No expenses found',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            TextButton.icon(
              onPressed: () {
                context.read<ExpenseProvider>().clearFilters();
                _searchController.clear();
                setState(() {
                  _showSearch = false;
                });
              },
              icon: const Icon(Icons.filter_alt_off_rounded),
              label: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the total footer
  Widget _buildTotalFooter(ThemeData theme) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.filteredExpenses.length} expenses',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  formatCurrency(provider.filteredTotal),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows options for an expense (edit/delete)
  void _showExpenseOptions(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expense preview
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: expense.category.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        child: Icon(
                          expense.category.icon,
                          color: expense.category.color,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              formatCurrency(expense.amount),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddExpenseScreen(expense: expense),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Delete',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context, expense.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows delete confirmation dialog
  void _confirmDelete(BuildContext context, String expenseId) {
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
                context.read<ExpenseProvider>().deleteExpense(expenseId);
                Navigator.pop(dialogContext);
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
