// =============================================================================
// Helpers - Utility functions for the expense tracker app
// =============================================================================

import 'package:intl/intl.dart';

/// Formats a double amount as currency (USD)
String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

/// Formats a DateTime to a readable date string
String formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

/// Formats a DateTime to a short date string
String formatDateShort(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateOnly = DateTime(date.year, date.month, date.day);

  if (dateOnly == today) {
    return 'Today';
  } else if (dateOnly == yesterday) {
    return 'Yesterday';
  } else if (date.year == now.year) {
    return DateFormat('MMM d').format(date);
  } else {
    return DateFormat('MMM d, yyyy').format(date);
  }
}

/// Formats a DateTime to show month and year
String formatMonthYear(DateTime date) {
  return DateFormat('MMMM yyyy').format(date);
}

/// Returns a greeting based on the current time of day
String getGreeting() {
  final hour = DateTime.now().hour;
  
  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

/// Checks if two dates are the same day
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

/// Checks if a date is in the current month
bool isCurrentMonth(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year && date.month == now.month;
}

/// Gets the start of the current month
DateTime getStartOfMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
}

/// Gets the end of the current month
DateTime getEndOfMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
}

/// Generates a unique ID based on timestamp
String generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}
