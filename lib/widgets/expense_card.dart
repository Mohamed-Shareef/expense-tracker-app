// =============================================================================
// Expense Card Widget - Displays a single expense item
// =============================================================================

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// A card widget that displays a single expense with its details
class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showDate;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
    this.onLongPress,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall / 2,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Category icon container
              _buildCategoryIcon(isDark),
              
              const SizedBox(width: AppConstants.paddingMedium),
              
              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          expense.category.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: expense.category.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (showDate) ...[
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatDateShort(expense.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Amount
              Text(
                formatCurrency(expense.amount),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the category icon with colored background
  Widget _buildCategoryIcon(bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: expense.category.color.withOpacity(isDark ? 0.2 : 0.15),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Icon(
        expense.category.icon,
        color: expense.category.color,
        size: 24,
      ),
    );
  }
}

/// A smaller, compact version of the expense card for lists
class ExpenseCardCompact extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseCardCompact({
    super.key,
    required this.expense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall / 2,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: expense.category.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        ),
        child: Icon(
          expense.category.icon,
          color: expense.category.color,
          size: 20,
        ),
      ),
      title: Text(
        expense.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        formatDateShort(expense.date),
        style: theme.textTheme.bodySmall,
      ),
      trailing: Text(
        formatCurrency(expense.amount),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
