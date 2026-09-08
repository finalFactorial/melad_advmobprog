import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get themeData {
    if (_isDarkMode) {
      return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF18191A),
        cardColor: const Color(0xFF242526),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1877F2),
          surface: Color(0xFF242526),
        ),
      );
    }
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFF0F2F5),
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1877F2),
        surface: Colors.white,
      ),
    );
  }
}
