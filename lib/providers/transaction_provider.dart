import 'package:flutter/foundation.dart';
import 'package:financetracker/models/transaction.dart';
import 'package:financetracker/services/database_service.dart';
import 'package:financetracker/services/firebase_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final FirebaseService _firebaseService = FirebaseService();

  List<Transaction> _transactions = [];
  List<Budget> _budgets = [];
  bool _isSyncing = false;
  bool _isCloudSyncEnabled = false;

  List<Transaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;
  bool get isSyncing => _isSyncing;
  bool get isCloudSyncEnabled => _isCloudSyncEnabled;

  TransactionProvider() {
    _loadTransactions();
    _loadBudgets();
  }

  void setCloudSyncEnabled(bool enabled) {
    _isCloudSyncEnabled = enabled;
    if (enabled) {
      syncWithCloud();
    }
    notifyListeners();
  }

  Future<void> _loadTransactions() async {
  //  _transactions = await _dbService.getTransactions();
    notifyListeners();
  }

  Future<void> _loadBudgets() async {
    _budgets = await _dbService.getBudgets();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _dbService.insertTransaction(transaction);
    await _loadTransactions();

    if (_isCloudSyncEnabled) {
      _syncTransactionsToCloud();
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _dbService.updateTransaction(transaction);
    await _loadTransactions();

    if (_isCloudSyncEnabled) {
      _syncTransactionsToCloud();
    }
  }

  Future<void> deleteTransaction(String id) async {
    await _dbService.deleteTransaction(id);
    await _loadTransactions();

    if (_isCloudSyncEnabled) {
      _syncTransactionsToCloud();
    }
  }

  Future<void> addBudget(Budget budget) async {
    await _dbService.insertBudget(budget);
    await _loadBudgets();

    if (_isCloudSyncEnabled) {
      _syncBudgetsToCloud();
    }
  }

  Future<void> updateBudget(Budget budget) async {
    await _dbService.updateBudget(budget);
    await _loadBudgets();

    if (_isCloudSyncEnabled) {
      _syncBudgetsToCloud();
    }
  }

  Future<void> deleteBudget(String id) async {
    await _dbService.deleteBudget(id);
    await _loadBudgets();

    if (_isCloudSyncEnabled) {
      _syncBudgetsToCloud();
    }
  }

  Future<void> syncWithCloud() async {
    if (!_isCloudSyncEnabled || _firebaseService.currentUser == null) return;

    _isSyncing = true;
    notifyListeners();

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _isSyncing = false;
        notifyListeners();
        return;
      }

      // Fetch from cloud first
      List<Transaction> cloudTransactions =
          await _firebaseService.fetchTransactions();
      List<Budget> cloudBudgets = await _firebaseService.fetchBudgets();

      // If cloud has data and local is empty, use cloud data
      if (cloudTransactions.isNotEmpty && _transactions.isEmpty) {
        for (var transaction in cloudTransactions) {
          await _dbService.insertTransaction(transaction);
        }
        await _loadTransactions();
      } else {
        // Otherwise, push local to cloud
        await _syncTransactionsToCloud();
      }

      if (cloudBudgets.isNotEmpty && _budgets.isEmpty) {
        for (var budget in cloudBudgets) {
          await _dbService.insertBudget(budget);
        }
        await _loadBudgets();
      } else {
        await _syncBudgetsToCloud();
      }
    } catch (e) {
      print('Error syncing with cloud: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> _syncTransactionsToCloud() async {
    if (!_isCloudSyncEnabled || _firebaseService.currentUser == null) return;

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        await _firebaseService.syncTransactions(_transactions);
      }
    } catch (e) {
      print('Error syncing transactions to cloud: $e');
    }
  }

  Future<void> _syncBudgetsToCloud() async {
    if (!_isCloudSyncEnabled || _firebaseService.currentUser == null) return;

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        await _firebaseService.syncBudgets(_budgets);
      }
    } catch (e) {
      print('Error syncing budgets to cloud: $e');
    }
  }

  // Analytics methods
  double getTotalIncome() {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getTotalExpense() {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getSavings() {
    return getTotalIncome() - getTotalExpense();
  }

  Map<String, double> getCategoryExpenses() {
    Map<String, double> result = {};

    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        if (result.containsKey(transaction.category)) {
          result[transaction.category] =
              result[transaction.category]! + transaction.amount;
        } else {
          result[transaction.category] = transaction.amount;
        }
      }
    }

    return result;
  }

  List<Map<String, dynamic>> getMonthlyData(int months) {
    List<Map<String, dynamic>> result = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < months; i++) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      DateTime nextMonth = DateTime(month.year, month.month + 1, 1);

      double income = _transactions
          .where((t) => t.type == TransactionType.income)
          .where((t) => t.date.isAfter(month) && t.date.isBefore(nextMonth))
          .fold(0, (sum, t) => sum + t.amount);

      double expense = _transactions
          .where((t) => t.type == TransactionType.expense)
          .where((t) => t.date.isAfter(month) && t.date.isBefore(nextMonth))
          .fold(0, (sum, t) => sum + t.amount);

      result.add({
        'month': '${month.month}/${month.year}',
        'income': income,
        'expense': expense,
        'savings': income - expense,
      });
    }

    return result.reversed.toList();
  }

  List<String> getBudgetInsights() {
    List<String> insights = [];

    // Check if any budget is close to or exceeding limit
    for (var budget in _budgets) {
      double spent = _transactions
          .where((t) => t.type == TransactionType.expense)
          .where((t) => t.category == budget.category)
          .where((t) =>
              t.date.isAfter(budget.startDate) &&
              t.date.isBefore(budget.endDate))
          .fold(0, (sum, t) => sum + t.amount);

      double percentage = (spent / budget.limit) * 100;

      if (percentage >= 90) {
        insights.add(
            'You\'ve used ${percentage.toStringAsFixed(0)}% of your ${budget.category} budget.');
      }
    }

    // Check for unusual spending
    Map<String, double> categoryExpenses = getCategoryExpenses();
    if (categoryExpenses.isNotEmpty) {
      var highestCategory =
          categoryExpenses.entries.reduce((a, b) => a.value > b.value ? a : b);

      insights.add(
          'Your highest spending category is ${highestCategory.key} (${highestCategory.value.toStringAsFixed(2)}).');
    }

    // Savings rate
    double income = getTotalIncome();
    double savings = getSavings();
    if (income > 0) {
      double savingsRate = (savings / income) * 100;
      if (savingsRate < 20) {
        insights.add(
            'Your savings rate is ${savingsRate.toStringAsFixed(0)}%. Try to aim for at least 20%.');
      } else {
        insights.add(
            'Great job! Your savings rate is ${savingsRate.toStringAsFixed(0)}%.');
      }
    }

    return insights;
  }
}
