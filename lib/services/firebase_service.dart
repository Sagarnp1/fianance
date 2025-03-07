import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financetracker/models/transaction.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore methods
  Future<void> syncTransactions(List<Transaction> transactions) async {
    if (currentUser == null) return;

    final batch = _firestore.batch();
    final userTransactionsRef = _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('transactions');

    // First, delete all existing transactions
    QuerySnapshot existingTransactions = await userTransactionsRef.get();
    for (var doc in existingTransactions.docs) {
      batch.delete(doc.reference);
    }

    // Then, add all current transactions
    for (var transaction in transactions) {
      batch.set(
        userTransactionsRef.doc(transaction.id),
        transaction.toMap(),
      );
    }

    await batch.commit();
  }

  Future<List<Transaction>> fetchTransactions() async {
    if (currentUser == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('transactions')
          .get();

      return snapshot.docs
          .map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> syncBudgets(List<Budget> budgets) async {
    if (currentUser == null) return;

    final batch = _firestore.batch();
    final userBudgetsRef = _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('budgets');

    // First, delete all existing budgets
    QuerySnapshot existingBudgets = await userBudgetsRef.get();
    for (var doc in existingBudgets.docs) {
      batch.delete(doc.reference);
    }

    // Then, add all current budgets
    for (var budget in budgets) {
      batch.set(
        userBudgetsRef.doc(budget.id),
        budget.toMap(),
      );
    }

    await batch.commit();
  }

  Future<List<Budget>> fetchBudgets() async {
    if (currentUser == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('budgets')
          .get();

      return snapshot.docs
          .map((doc) => Budget.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
