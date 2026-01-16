// =============================================================================
// Personal Expense Tracker App
// A complete expense tracking app with Material Design 3
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/expense_provider.dart';
import 'providers/theme_provider.dart';

// Utils
import 'utils/constants.dart';

// Screens
import 'screens/home_screen.dart';

/// Main entry point of the application
void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const ExpenseTrackerApp());
}

/// Root widget of the Expense Tracker application
/// Sets up providers and theme configuration
class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme provider for dark/light mode management
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // Expense provider for managing expense data
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            // App title
            title: 'Expense Tracker',
            
            // Remove debug banner
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.flutterThemeMode,
            
            // Home screen
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
