import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? note;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'type': type.toString(),
      'category': category,
      'note': note,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      type: map['type'] == 'TransactionType.income' 
          ? TransactionType.income 
          : TransactionType.expense,
      category: map['category'],
      note: map['note'],
    );
  }
}

class Budget {
  final String id;
  final String category;
  final double limit;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    String? id,
    required this.category,
    required this.limit,
    required this.startDate,
    required this.endDate,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      limit: map['limit'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
    );
  }
}

