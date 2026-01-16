// =============================================================================
// Settings Screen - Theme toggle, reset data, and about app
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

/// Settings screen with theme options and app information
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          // Theme section
          _buildSectionTitle(theme, 'Appearance'),
          _buildThemeCard(context, theme),

          const SizedBox(height: AppConstants.paddingLarge),

          // Data section
          _buildSectionTitle(theme, 'Data'),
          _buildDataCard(context, theme),

          const SizedBox(height: AppConstants.paddingLarge),

          // About section
          _buildSectionTitle(theme, 'About'),
          _buildAboutCard(context, theme),
        ],
      ),
    );
  }

  /// Builds a section title
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.paddingSmall,
        bottom: AppConstants.paddingSmall,
      ),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds the theme options card
  Widget _buildThemeCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Column(
            children: [
              _buildThemeOption(
                context: context,
                theme: theme,
                title: 'System',
                subtitle: 'Follow device settings',
                icon: Icons.brightness_auto_rounded,
                isSelected: themeProvider.themeMode == AppThemeMode.system,
                onTap: () => themeProvider.setThemeMode(AppThemeMode.system),
              ),
              const Divider(height: 1),
              _buildThemeOption(
                context: context,
                theme: theme,
                title: 'Light',
                subtitle: 'Always use light theme',
                icon: Icons.light_mode_rounded,
                isSelected: themeProvider.themeMode == AppThemeMode.light,
                onTap: () => themeProvider.setThemeMode(AppThemeMode.light),
              ),
              const Divider(height: 1),
              _buildThemeOption(
                context: context,
                theme: theme,
                title: 'Dark',
                subtitle: 'Always use dark theme',
                icon: Icons.dark_mode_rounded,
                isSelected: themeProvider.themeMode == AppThemeMode.dark,
                onTap: () => themeProvider.setThemeMode(AppThemeMode.dark),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Builds a single theme option row
  Widget _buildThemeOption({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }

  /// Builds the data management card
  Widget _buildDataCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.refresh_rounded),
            title: const Text('Reset Mock Data'),
            subtitle: const Text('Restore sample expenses'),
            onTap: () => _confirmResetData(context),
          ),
          const Divider(height: 1),
          Consumer<ExpenseProvider>(
            builder: (context, provider, child) {
              return ListTile(
                leading: const Icon(Icons.bar_chart_rounded),
                title: const Text('Statistics'),
                subtitle: Text('${provider.expenseCount} total expenses'),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds the about card
  Widget _buildAboutCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            title: const Text('Expense Tracker'),
            subtitle: const Text('Version 1.0.0'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.code_rounded),
            title: const Text('Built with Flutter'),
            subtitle: const Text('Material Design 3'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.favorite_rounded, color: Colors.red),
            title: const Text('Made with ❤️'),
            subtitle: const Text('Personal expense tracking app'),
          ),
        ],
      ),
    );
  }

  /// Shows confirmation dialog for resetting data
  void _confirmResetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Data'),
          content: const Text(
            'This will delete all your current expenses and restore the sample data. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ExpenseProvider>().resetMockData();
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mock data restored')),
                );
              },
              child: Text(
                'Reset',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
