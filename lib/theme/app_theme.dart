import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color incomeColor = Color(0xFF4CAF50);
  static const Color expenseColor = Color(0xFFF44336);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Colors.white;
  static const Color lightTextColor = Colors.black87;
  
  // Text Styles
  static final TextStyle headingStyle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static final TextStyle subheadingStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static final TextStyle bodyStyle = GoogleFonts.poppins(
    fontSize: 14,
  );
  
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: cardColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headingStyle.copyWith(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: headingStyle.copyWith(color: lightTextColor),
      displayMedium: subheadingStyle.copyWith(color: lightTextColor),
      bodyLarge: bodyStyle.copyWith(color: lightTextColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.5);
      }),
    ),
  );
  
  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: darkBackgroundColor,
      surface: darkCardColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    cardTheme: CardTheme(
      color: darkCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkCardColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headingStyle.copyWith(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: headingStyle.copyWith(color: darkTextColor),
      displayMedium: subheadingStyle.copyWith(color: darkTextColor),
      bodyLarge: bodyStyle.copyWith(color: Colors.white70),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.5);
      }),
    ),
  );
}

