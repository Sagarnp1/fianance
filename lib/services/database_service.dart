import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:financetracker/models/transaction.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        date INTEGER,
        type TEXT,
        category TEXT,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets(
        id TEXT PRIMARY KEY,
        category TEXT,
        limit REAL,
        startDate INTEGER,
        endDate INTEGER
      )
    ''');
  }

  // Transaction methods
  Future<void> insertTransaction(Transaction transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Budget methods
  Future<void> insertBudget(Budget budget) async {
    final db = await database;
    await db.insert(
      'budgets',
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }

  Future<void> updateBudget(Budget budget) async {
    final db = await database;
    await db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<void> deleteBudget(String id) async {
    final db = await database;
    await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
