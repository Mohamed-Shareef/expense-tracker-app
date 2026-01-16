// =============================================================================
// Category Chip Widget - Selectable category filter chip
// =============================================================================

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/constants.dart';

/// A chip widget for displaying and selecting expense categories
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showLabel;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationShort,
        padding: EdgeInsets.symmetric(
          horizontal: showLabel ? AppConstants.paddingMedium : AppConstants.paddingSmall,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withOpacity(isDark ? 0.3 : 0.2)
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          border: Border.all(
            color: isSelected ? category.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color: isSelected ? category.color : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 20,
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                category.displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? category.color : (isDark ? Colors.grey[300] : Colors.grey[700]),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A row of all category chips for filtering
class CategoryFilterRow extends StatelessWidget {
  final Category? selectedCategory;
  final Function(Category?) onCategorySelected;
  final bool showAllOption;

  const CategoryFilterRow({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Row(
        children: [
          // "All" option
          if (showAllOption) ...[
            GestureDetector(
              onTap: () => onCategorySelected(null),
              child: AnimatedContainer(
                duration: AppConstants.animationShort,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: selectedCategory == null
                      ? theme.colorScheme.primary.withOpacity(0.2)
                      : (isDark ? Colors.grey[800] : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  border: Border.all(
                    color: selectedCategory == null ? theme.colorScheme.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  'All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: selectedCategory == null
                        ? theme.colorScheme.primary
                        : (isDark ? Colors.grey[300] : Colors.grey[700]),
                    fontWeight: selectedCategory == null ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          // Category chips
          ...Category.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryChip(
                category: category,
                isSelected: selectedCategory == category,
                onTap: () => onCategorySelected(
                  selectedCategory == category ? null : category,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// A grid of category chips for selection (used in forms)
class CategorySelectionGrid extends StatelessWidget {
  final Category selectedCategory;
  final Function(Category) onCategorySelected;

  const CategorySelectionGrid({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Category.values.map((category) {
        return CategoryChip(
          category: category,
          isSelected: selectedCategory == category,
          onTap: () => onCategorySelected(category),
        );
      }).toList(),
    );
  }
}
