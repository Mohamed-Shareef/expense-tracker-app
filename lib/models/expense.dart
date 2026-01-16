// =============================================================================
// Expense Model - Core data model for the expense tracker app
// =============================================================================

import 'package:flutter/material.dart';

/// Enum representing the different expense categories
/// Each category has an associated icon and color for display
enum Category {
  food,
  transport,
  shopping,
  bills,
  entertainment,
  other,
}

/// Extension on Category to add helper methods for icons and colors
extension CategoryExtension on Category {
  /// Returns the display name for the category
  String get displayName {
    switch (this) {
      case Category.food:
        return 'Food';
      case Category.transport:
        return 'Transport';
      case Category.shopping:
        return 'Shopping';
      case Category.bills:
        return 'Bills';
      case Category.entertainment:
        return 'Entertainment';
      case Category.other:
        return 'Other';
    }
  }

  /// Returns the icon for the category
  IconData get icon {
    switch (this) {
      case Category.food:
        return Icons.restaurant_rounded;
      case Category.transport:
        return Icons.directions_car_rounded;
      case Category.shopping:
        return Icons.shopping_bag_rounded;
      case Category.bills:
        return Icons.receipt_long_rounded;
      case Category.entertainment:
        return Icons.movie_rounded;
      case Category.other:
        return Icons.more_horiz_rounded;
    }
  }

  /// Returns the color for the category
  Color get color {
    switch (this) {
      case Category.food:
        return const Color(0xFFFF6B6B); // Coral red
      case Category.transport:
        return const Color(0xFF4ECDC4); // Teal
      case Category.shopping:
        return const Color(0xFFFFE66D); // Yellow
      case Category.bills:
        return const Color(0xFF95E1D3); // Mint
      case Category.entertainment:
        return const Color(0xFFDDA0DD); // Plum
      case Category.other:
        return const Color(0xFF95A5A6); // Gray
    }
  }
}

/// Expense class representing a single expense entry
class Expense {
  final String id;
  final String title;
  final double amount;
  final Category category;
  final DateTime date;
  final String? note;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  /// Creates an Expense from a Map (for serialization)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: Category.values[map['category'] as int],
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
    );
  }

  /// Converts the Expense to a Map (for serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.index,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  /// Creates a copy of the expense with updated fields
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    Category? category,
    DateTime? date,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, category: ${category.displayName}, date: $date)';
  }
}
