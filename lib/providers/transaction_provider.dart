import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  late Box<Transaction> _transactionBox;
  final _uuid = const Uuid();
  
  List<Transaction> _transactions = [];
  bool _isInitialized = false;
  
  TransactionProvider() {
    _initHive();
  }
  
  Future<void> _initHive() async {
    if (Hive.isBoxOpen('transactions')) {
      _transactionBox = Hive.box<Transaction>('transactions');
    } else {
      _transactionBox = await Hive.openBox<Transaction>('transactions');
    }
    
    _loadTransactions();
    _isInitialized = true;
    
    // Add some sample data if the box is empty
    if (_transactions.isEmpty) {
      _addSampleData();
    }
  }
  
  void _loadTransactions() {
    _transactions = _transactionBox.values.toList();
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }
  
  List<Transaction> get transactions => _transactions;
  
  List<Transaction> get incomeTransactions => 
      _transactions.where((t) => t.type == TransactionType.income).toList();
  
  List<Transaction> get expenseTransactions => 
      _transactions.where((t) => t.type == TransactionType.expense).toList();
  
  double get totalIncome => incomeTransactions.fold(
      0, (sum, transaction) => sum + transaction.amount);
  
  double get totalExpense => expenseTransactions.fold(
      0, (sum, transaction) => sum + transaction.amount);
  
  double get balance => totalIncome - totalExpense;
  
  Future<void> addTransaction(
    String title,
    double amount,
    DateTime date,
    TransactionType type,
    String category,
    String? note,
  ) async {
    final transaction = Transaction(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: date,
      type: type,
      category: category,
      note: note,
    );
    
    await _transactionBox.add(transaction);
    _loadTransactions();
  }
  
  Future<void> deleteTransaction(String id) async {
    final transactionToDelete = _transactions.firstWhere((t) => t.id == id);
    await transactionToDelete.delete();
    _loadTransactions();
  }
  
  Map<String, double> getCategoryTotals(TransactionType type) {
    final filteredTransactions = _transactions.where((t) => t.type == type).toList();
    final Map<String, double> categoryTotals = {};
    
    for (var transaction in filteredTransactions) {
      if (categoryTotals.containsKey(transaction.category)) {
        categoryTotals[transaction.category] = 
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      } else {
        categoryTotals[transaction.category] = transaction.amount;
      }
    }
    
    return categoryTotals;
  }
  
  Map<DateTime, double> getMonthlyData(TransactionType type) {
    final filteredTransactions = _transactions.where((t) => t.type == type).toList();
    final Map<DateTime, double> monthlyData = {};
    
    for (var transaction in filteredTransactions) {
      final date = DateTime(transaction.date.year, transaction.date.month, 1);
      
      if (monthlyData.containsKey(date)) {
        monthlyData[date] = (monthlyData[date] ?? 0) + transaction.amount;
      } else {
        monthlyData[date] = transaction.amount;
      }
    }
    
    return monthlyData;
  }
  
  // Add sample data for testing
  Future<void> _addSampleData() async {
    final now = DateTime.now();
    
    // Sample income transactions
    await addTransaction(
      'Salary',
      3500.0,
      now.subtract(const Duration(days: 2)),
      TransactionType.income,
      'Salary',
      'Monthly salary',
    );
    
    await addTransaction(
      'Freelance Project',
      850.0,
      now.subtract(const Duration(days: 10)),
      TransactionType.income,
      'Freelance',
      'Website development',
    );
    
    // Sample expense transactions
    await addTransaction(
      'Groceries',
      120.50,
      now.subtract(const Duration(days: 1)),
      TransactionType.expense,
      'Food',
      'Weekly grocery shopping',
    );
    
    await addTransaction(
      'Electricity Bill',
      85.75,
      now.subtract(const Duration(days: 5)),
      TransactionType.expense,
      'Utilities',
      'Monthly electricity bill',
    );
    
    await addTransaction(
      'Restaurant',
      45.80,
      now.subtract(const Duration(days: 3)),
      TransactionType.expense,
      'Food',
      'Dinner with friends',
    );
    
    await addTransaction(
      'Gas',
      35.40,
      now.subtract(const Duration(days: 4)),
      TransactionType.expense,
      'Transportation',
      'Car refuel',
    );
  }
}

