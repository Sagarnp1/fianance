import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financetracker/providers/auth_provider.dart';
import 'package:financetracker/providers/transaction_provider.dart';
import 'package:financetracker/screens/add_transaction_screen.dart';
import 'package:financetracker/screens/analytics_screen.dart';
import 'package:financetracker/screens/budget_screen.dart';
import 'package:financetracker/screens/settings_screen.dart';
import 'package:financetracker/widgets/transaction_list.dart';
import 'package:financetracker/widgets/summary_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).syncWithCloud();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddTransactionScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const AnalyticsScreen();
      case 2:
        return const BudgetScreen();
      case 3:
        return const SettingsScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            SummaryCards(
              income: provider.getTotalIncome(),
              expense: provider.getTotalExpense(),
              savings: provider.getSavings(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TransactionList(
                transactions: provider.transactions,
              ),
            ),
          ],
        );
      },
    );
  }
}
