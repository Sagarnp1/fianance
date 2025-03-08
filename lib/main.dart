import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'models/transaction.dart';
import 'providers/transaction_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

// Note: Before running the app, execute this command to generate the Hive adapters:
// flutter pub run build_runner build

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register the adapters that will be generated after running build_runner
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionTypeAdapter());
  }
  
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TransactionAdapter());
  }
  
  // Open the box
  await Hive.openBox<Transaction>('transactions');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Finance Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

