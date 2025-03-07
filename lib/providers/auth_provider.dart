import 'package:flutter/foundation.dart';
import 'package:financetracker/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _error;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      _status =
          user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _error = null;
      User? user = await _firebaseService.signUp(email, password);
      return user != null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _error = null;
      User? user = await _firebaseService.signIn(email, password);
      return user != null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
  }
}
