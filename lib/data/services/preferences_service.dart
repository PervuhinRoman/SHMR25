import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _selectedCurrencyKey = 'selected_currency';
  static const String _selectedCurrencySymbolKey = 'selected_currency_symbol';
  
  // Получить выбранную валюту (код)
  static Future<String> getSelectedCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedCurrencyKey) ?? 'RUB';
    } catch (e) {
      log('❌ Ошибка при получении валюты из SharedPreferences: $e', name: "SharedPrefs");
      return 'RUB'; // Fallback к рублю
    }
  }

  // Получить символ выбранной валюты
  static Future<String> getSelectedCurrencySymbol() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedCurrencySymbolKey) ?? '₽';
    } catch (e) {
      log('❌ Ошибка при получении символа валюты из SharedPreferences: $e', name: "SharedPrefs");
      return '₽'; // Fallback к рублю
    }
  }
  
  // Сохранить выбранную валюту
  static Future<void> setSelectedCurrency(String currencyCode, String currencySymbol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedCurrencyKey, currencyCode);
      await prefs.setString(_selectedCurrencySymbolKey, currencySymbol);
      log('✅ Валюта успешно сохранена: $currencyCode ($currencySymbol)', name: "SharedPrefs");
    } catch (e) {
      log('❌ Ошибка при сохранении валюты в SharedPreferences: $e', name: "SharedPrefs");
      // Не выбрасываем исключение, чтобы не ломать UI
    }
  }
} 