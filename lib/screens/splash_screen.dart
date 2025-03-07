import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financetracker/providers/auth_provider.dart';
import 'package:financetracker/screens/home_screen.dart';
import 'package:financetracker/screens/auth_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.status == AuthStatus.initial) {
      // Wait for auth state to be determined
      authProvider.addListener(_onAuthStateChanged);
    } else {
      _navigateBasedOnAuth(authProvider.status);
    }
  }

  void _onAuthStateChanged() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.status != AuthStatus.initial) {
      authProvider.removeListener(_onAuthStateChanged);
      _navigateBasedOnAuth(authProvider.status);
    }
  }

  void _navigateBasedOnAuth(AuthStatus status) {
    if (status == AuthStatus.authenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://assets9.lottiefiles.com/packages/lf20_jvkRPe.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Text(
              'Finance Tracker',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your money wisely',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
