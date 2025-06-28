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
      print('❌ Ошибка при получении валюты из SharedPreferences: $e');
      return 'RUB'; // Fallback к рублю
    }
  }

  // Получить символ выбранной валюты
  static Future<String> getSelectedCurrencySymbol() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedCurrencySymbolKey) ?? '₽';
    } catch (e) {
      print('❌ Ошибка при получении символа валюты из SharedPreferences: $e');
      return '₽'; // Fallback к рублю
    }
  }
  
  // Сохранить выбранную валюту
  static Future<void> setSelectedCurrency(String currencyCode, String currencySymbol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedCurrencyKey, currencyCode);
      await prefs.setString(_selectedCurrencySymbolKey, currencySymbol);
      print('✅ Валюта успешно сохранена: $currencyCode ($currencySymbol)');
    } catch (e) {
      print('❌ Ошибка при сохранении валюты в SharedPreferences: $e');
      // Не выбрасываем исключение, чтобы не ломать UI
    }
  }
} 