import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _useSystemThemeKey = 'use_system_theme';
  static const String _primaryColorKey = 'primary_color';

  static const Color _defaultPrimaryColor = Color(0xff2ae881);

  bool _useSystemTheme = true;
  Color _primaryColor = _defaultPrimaryColor;

  bool get useSystemTheme => _useSystemTheme;
  Color get primaryColor => _primaryColor;

  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  Future<void> initialize() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _useSystemTheme = prefs.getBool(_useSystemThemeKey) ?? true;
    final colorValue = prefs.getInt(_primaryColorKey);
    if (colorValue != null) {
      _primaryColor = Color(colorValue);
    }

    notifyListeners();
  }

  Future<void> setUseSystemTheme(bool value) async {
    if (_useSystemTheme != value) {
      _useSystemTheme = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useSystemThemeKey, value);
      notifyListeners();
    }
  }

  Future<void> setPrimaryColor(Color color) async {
    if (_primaryColor != color) {
      _primaryColor = color;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_primaryColorKey, color.toARGB32());
      notifyListeners();
    }
  }

  ThemeMode getThemeMode() {
    return _useSystemTheme ? ThemeMode.system : ThemeMode.light;
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        primaryContainer: _primaryColor.withValues(alpha: 0.1),
        secondary: _primaryColor,
        secondaryContainer: _primaryColor.withValues(alpha: 0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: _primaryColor.withValues(alpha: 0.2),
        backgroundColor: const Color(0xffF3EDF7),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        primaryContainer: _primaryColor.withValues(alpha: 0.2),
        secondary: _primaryColor,
        secondaryContainer: _primaryColor.withValues(alpha: 0.2),
        surface: const Color(0xFF1E1E1E),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: _primaryColor.withValues(alpha: 0.3),
        backgroundColor: const Color(0xFF1E1E1E),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
