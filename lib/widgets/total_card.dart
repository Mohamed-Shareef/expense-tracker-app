// =============================================================================
// Total Card Widget - Displays expense totals with gradient background
// =============================================================================

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// A large card widget displaying total expenses with gradient background
class TotalCard extends StatelessWidget {
  final String title;
  final double amount;
  final String? subtitle;
  final IconData? icon;
  final List<Color>? gradientColors;

  const TotalCard({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    this.icon,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default gradient colors based on theme
    final colors = gradientColors ??
        (isDark
            ? [
                const Color(0xFF6750A4),
                const Color(0xFF9C27B0),
              ]
            : [
                const Color(0xFF7C4DFF),
                const Color(0xFFB388FF),
              ]);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            formatCurrency(amount),
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A smaller stat card for quick info display
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A row of stat cards
class StatsRow extends StatelessWidget {
  final double todayTotal;
  final int totalExpenses;
  final double monthlyTotal;

  const StatsRow({
    super.key,
    required this.todayTotal,
    required this.totalExpenses,
    required this.monthlyTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: 'Today',
              value: formatCurrency(todayTotal),
              icon: Icons.today_rounded,
              iconColor: const Color(0xFF4ECDC4),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: StatCard(
              title: 'Transactions',
              value: totalExpenses.toString(),
              icon: Icons.receipt_long_rounded,
              iconColor: const Color(0xFFFF6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
