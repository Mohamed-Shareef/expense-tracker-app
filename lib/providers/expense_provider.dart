// =============================================================================
// Expense Provider - Manages expense data with CRUD operations
// =============================================================================

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/helpers.dart';

/// Provider for managing expense state
class ExpenseProvider extends ChangeNotifier {
  // List of all expenses
  List<Expense> _expenses = [];

  // Search query for filtering
  String _searchQuery = '';

  // Selected category for filtering (null means all)
  Category? _selectedCategory;

  // Selected month for filtering (null means all)
  DateTime? _selectedMonth;

  /// Constructor - initializes with mock data
  ExpenseProvider() {
    _initializeMockData();
  }

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  /// Returns all expenses (unfiltered)
  List<Expense> get allExpenses => List.unmodifiable(_expenses);

  /// Returns filtered expenses based on search, category, and month
  List<Expense> get filteredExpenses {
    var filtered = List<Expense>.from(_expenses);

    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered
          .where((expense) => expense.category == _selectedCategory)
          .toList();
    }

    // Filter by month
    if (_selectedMonth != null) {
      filtered = filtered.where((expense) {
        return expense.date.year == _selectedMonth!.year &&
            expense.date.month == _selectedMonth!.month;
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((expense) {
        return expense.title.toLowerCase().contains(query) ||
            (expense.note?.toLowerCase().contains(query) ?? false) ||
            expense.category.displayName.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => b.date.compareTo(a.date));

    return filtered;
  }

  /// Returns recent 5 expenses
  List<Expense> get recentExpenses {
    final sorted = List<Expense>.from(_expenses)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  /// Returns expenses for the current month
  List<Expense> get currentMonthExpenses {
    final now = DateTime.now();
    return _expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();
  }

  /// Calculates total for the current month
  double get monthlyTotal {
    return currentMonthExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Calculates total for today
  double get todayTotal {
    final today = DateTime.now();
    return _expenses.where((expense) => isSameDay(expense.date, today))
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Calculates total for all expenses
  double get grandTotal {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Calculates total for filtered expenses
  double get filteredTotal {
    return filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Returns total expenses by category for current month
  Map<Category, double> get categoryTotals {
    final totals = <Category, double>{};
    for (final category in Category.values) {
      totals[category] = currentMonthExpenses
          .where((e) => e.category == category)
          .fold(0.0, (sum, e) => sum + e.amount);
    }
    return totals;
  }

  /// Returns expense count
  int get expenseCount => _expenses.length;

  /// Gets the search query
  String get searchQuery => _searchQuery;

  /// Gets the selected category filter
  Category? get selectedCategory => _selectedCategory;

  /// Gets the selected month filter
  DateTime? get selectedMonth => _selectedMonth;

  // ==========================================================================
  // CRUD OPERATIONS
  // ==========================================================================

  /// Adds a new expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  /// Updates an existing expense
  void updateExpense(String id, Expense updatedExpense) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      notifyListeners();
    }
  }

  /// Deletes an expense by ID
  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Gets an expense by ID
  Expense? getExpenseById(String id) {
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==========================================================================
  // FILTER OPERATIONS
  // ==========================================================================

  /// Sets the search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Sets the category filter
  void setSelectedCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Sets the month filter
  void setSelectedMonth(DateTime? month) {
    _selectedMonth = month;
    notifyListeners();
  }

  /// Clears all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedMonth = null;
    notifyListeners();
  }

  // ==========================================================================
  // MOCK DATA
  // ==========================================================================

  /// Resets to mock data
  void resetMockData() {
    _initializeMockData();
    clearFilters();
  }

  /// Initializes the provider with 25+ mock expenses
  void _initializeMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _expenses = [
      // Today's expenses
      Expense(
        id: '1',
        title: 'Morning Coffee',
        amount: 4.50,
        category: Category.food,
        date: today.add(const Duration(hours: 8)),
        note: 'Starbucks latte',
      ),
      Expense(
        id: '2',
        title: 'Uber to Office',
        amount: 12.75,
        category: Category.transport,
        date: today.add(const Duration(hours: 9)),
        note: 'Running late for meeting',
      ),
      Expense(
        id: '3',
        title: 'Lunch with Team',
        amount: 25.00,
        category: Category.food,
        date: today.add(const Duration(hours: 12)),
        note: 'Italian restaurant downtown',
      ),

      // Yesterday's expenses
      Expense(
        id: '4',
        title: 'Grocery Shopping',
        amount: 87.45,
        category: Category.shopping,
        date: today.subtract(const Duration(days: 1)),
        note: 'Weekly groceries from Whole Foods',
      ),
      Expense(
        id: '5',
        title: 'Netflix Subscription',
        amount: 15.99,
        category: Category.entertainment,
        date: today.subtract(const Duration(days: 1)),
        note: 'Monthly subscription',
      ),
      Expense(
        id: '6',
        title: 'Gas Station',
        amount: 45.00,
        category: Category.transport,
        date: today.subtract(const Duration(days: 1)),
        note: 'Full tank',
      ),

      // This week's expenses
      Expense(
        id: '7',
        title: 'Electricity Bill',
        amount: 125.00,
        category: Category.bills,
        date: today.subtract(const Duration(days: 2)),
        note: 'January electricity',
      ),
      Expense(
        id: '8',
        title: 'Movie Tickets',
        amount: 32.00,
        category: Category.entertainment,
        date: today.subtract(const Duration(days: 2)),
        note: 'Avatar 3 with friends',
      ),
      Expense(
        id: '9',
        title: 'Phone Case',
        amount: 29.99,
        category: Category.shopping,
        date: today.subtract(const Duration(days: 3)),
        note: 'New protective case',
      ),
      Expense(
        id: '10',
        title: 'Dinner Date',
        amount: 85.50,
        category: Category.food,
        date: today.subtract(const Duration(days: 3)),
        note: 'Anniversary dinner',
      ),
      Expense(
        id: '11',
        title: 'Internet Bill',
        amount: 79.99,
        category: Category.bills,
        date: today.subtract(const Duration(days: 4)),
        note: 'Fiber optic plan',
      ),
      Expense(
        id: '12',
        title: 'Spotify Premium',
        amount: 9.99,
        category: Category.entertainment,
        date: today.subtract(const Duration(days: 4)),
        note: 'Music subscription',
      ),

      // Last week's expenses
      Expense(
        id: '13',
        title: 'Train Ticket',
        amount: 35.00,
        category: Category.transport,
        date: today.subtract(const Duration(days: 5)),
        note: 'Weekend trip',
      ),
      Expense(
        id: '14',
        title: 'New Headphones',
        amount: 199.99,
        category: Category.shopping,
        date: today.subtract(const Duration(days: 6)),
        note: 'Sony WH-1000XM5',
      ),
      Expense(
        id: '15',
        title: 'Pizza Delivery',
        amount: 28.50,
        category: Category.food,
        date: today.subtract(const Duration(days: 6)),
        note: 'Game night pizza',
      ),
      Expense(
        id: '16',
        title: 'Gym Membership',
        amount: 50.00,
        category: Category.bills,
        date: today.subtract(const Duration(days: 7)),
        note: 'Monthly membership fee',
      ),
      Expense(
        id: '17',
        title: 'Concert Tickets',
        amount: 120.00,
        category: Category.entertainment,
        date: today.subtract(const Duration(days: 7)),
        note: 'Coldplay concert next month',
      ),

      // Earlier this month
      Expense(
        id: '18',
        title: 'Water Bill',
        amount: 45.00,
        category: Category.bills,
        date: today.subtract(const Duration(days: 8)),
        note: 'Quarterly water bill',
      ),
      Expense(
        id: '19',
        title: 'Books',
        amount: 42.99,
        category: Category.shopping,
        date: today.subtract(const Duration(days: 9)),
        note: 'Programming books from Amazon',
      ),
      Expense(
        id: '20',
        title: 'Breakfast Brunch',
        amount: 35.00,
        category: Category.food,
        date: today.subtract(const Duration(days: 10)),
        note: 'Sunday brunch with family',
      ),
      Expense(
        id: '21',
        title: 'Parking Fee',
        amount: 15.00,
        category: Category.transport,
        date: today.subtract(const Duration(days: 10)),
        note: 'Downtown parking',
      ),
      Expense(
        id: '22',
        title: 'New Shoes',
        amount: 89.99,
        category: Category.shopping,
        date: today.subtract(const Duration(days: 11)),
        note: 'Running shoes for gym',
      ),
      Expense(
        id: '23',
        title: 'Doctor Visit',
        amount: 50.00,
        category: Category.other,
        date: today.subtract(const Duration(days: 12)),
        note: 'Regular checkup copay',
      ),
      Expense(
        id: '24',
        title: 'Car Wash',
        amount: 25.00,
        category: Category.transport,
        date: today.subtract(const Duration(days: 13)),
        note: 'Full service wash',
      ),
      Expense(
        id: '25',
        title: 'Streaming Bundle',
        amount: 29.99,
        category: Category.entertainment,
        date: today.subtract(const Duration(days: 14)),
        note: 'Disney+ and Hulu bundle',
      ),

      // Additional varied expenses
      Expense(
        id: '26',
        title: 'Coffee Beans',
        amount: 18.99,
        category: Category.food,
        date: today.subtract(const Duration(days: 5)),
        note: 'Premium roast from local shop',
      ),
      Expense(
        id: '27',
        title: 'Phone Bill',
        amount: 85.00,
        category: Category.bills,
        date: today.subtract(const Duration(days: 3)),
        note: 'Monthly phone plan',
      ),
      Expense(
        id: '28',
        title: 'Birthday Gift',
        amount: 55.00,
        category: Category.other,
        date: today.subtract(const Duration(days: 8)),
        note: 'Gift for friend\'s birthday',
      ),
      Expense(
        id: '29',
        title: 'Haircut',
        amount: 35.00,
        category: Category.other,
        date: today.subtract(const Duration(days: 6)),
        note: 'Monthly haircut',
      ),
      Expense(
        id: '30',
        title: 'Pet Food',
        amount: 42.50,
        category: Category.shopping,
        date: today.subtract(const Duration(days: 4)),
        note: 'Dog food and treats',
      ),
    ];

    notifyListeners();
  }
}
