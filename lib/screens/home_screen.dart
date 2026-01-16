// =============================================================================
// Home Screen - Dashboard with greeting, stats, and recent transactions
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/expense_card.dart';
import '../widgets/total_card.dart';
import 'add_expense_screen.dart';
import 'expenses_screen.dart';
import 'settings_screen.dart';

/// Home screen displaying dashboard with monthly summary and recent expenses
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with greeting
            _buildAppBar(context, theme),

            // Main content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppConstants.paddingSmall),

                  // Monthly total card
                  _buildMonthlyTotalCard(context),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Quick stats row
                  _buildQuickStats(context),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Recent transactions header
                  _buildSectionHeader(context, theme),

                  const SizedBox(height: AppConstants.paddingSmall),
                ],
              ),
            ),

            // Recent transactions list
            _buildRecentTransactions(context),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  /// Builds the app bar with greeting and settings button
  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    final now = DateTime.now();

    return SliverAppBar(
      floating: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: AppConstants.paddingMedium,
          bottom: AppConstants.paddingMedium,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              formatDate(now),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Builds the monthly total card
  Widget _buildMonthlyTotalCard(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return TotalCard(
          title: 'Monthly Expenses',
          amount: provider.monthlyTotal,
          subtitle: formatMonthYear(DateTime.now()),
          icon: Icons.calendar_month_rounded,
        );
      },
    );
  }

  /// Builds the quick stats row
  Widget _buildQuickStats(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return StatsRow(
          todayTotal: provider.todayTotal,
          totalExpenses: provider.expenseCount,
          monthlyTotal: provider.monthlyTotal,
        );
      },
    );
  }

  /// Builds the section header with "See All" button
  Widget _buildSectionHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExpensesScreen()),
              );
            },
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

  /// Builds the recent transactions list
  Widget _buildRecentTransactions(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final recentExpenses = provider.recentExpenses;

        if (recentExpenses.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'No expenses yet',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'Tap + to add your first expense',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final expense = recentExpenses[index];
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
                  _showExpenseOptions(context, expense.id);
                },
              );
            },
            childCount: recentExpenses.length,
          ),
        );
      },
    );
  }

  /// Builds the floating action button
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        );
      },
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Expense'),
    );
  }

  /// Shows options for an expense (edit/delete)
  void _showExpenseOptions(BuildContext context, String expenseId) {
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
                ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    final expense = context.read<ExpenseProvider>().getExpenseById(expenseId);
                    if (expense != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddExpenseScreen(expense: expense),
                        ),
                      );
                    }
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
                    _confirmDelete(context, expenseId);
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ExpenseProvider>().deleteExpense(expenseId);
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
