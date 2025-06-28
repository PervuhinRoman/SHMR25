import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance/domain/models/currency/currency.dart';

part 'account_state.dart';

class MyAccountCubit extends Cubit<MyAccountState> {
  static const String _currencyCodeKey = 'selected_currency_code';
  static const String _currencySymbolKey = 'selected_currency_symbol';
  static const String _accountNameKey = 'account_name';

  MyAccountCubit() : super(MyAccountState(selectedCurrency: Currencies.available.first, isLoading: true)) {
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    try {
      print('📱 Загружаю данные аккаунта из SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      
      // Загружаем валюту
      final currencyCode = prefs.getString(_currencyCodeKey);
      final currencySymbol = prefs.getString(_currencySymbolKey);
      print('📱 Получен код валюты: $currencyCode, символ: $currencySymbol');
      
      Currency currency;
      if (currencyCode != null) {
        currency = Currencies.getByCode(currencyCode) ?? Currencies.available.first;
      } else {
        currency = Currencies.available.first;
      }
      print('📱 Найдена валюта: ${currency.code}');
      
      // Загружаем имя счета
      final accountName = prefs.getString(_accountNameKey) ?? 'Мой счёт';
      print('📱 Загружено имя счета: $accountName');
      
      emit(state.copyWith(
        selectedCurrency: currency,
        accountName: accountName,
        isLoading: false,
      ));
      print('📡 Состояние обновлено после загрузки: ${state.selectedCurrency.code}, ${state.accountName}');
    } catch (e) {
      print('❌ Ошибка при загрузке данных аккаунта: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> setCurrency(Currency currency) async {
    print('🔄 setCurrency вызван: ${currency.code} (${currency.symbol})');
    await _saveCurrencyToPrefs(currency.code, currency.symbol);
    print('💾 Валюта сохранена в SharedPreferences: ${currency.code} (${currency.symbol})');
    emit(state.copyWith(selectedCurrency: currency));
    print('📡 Состояние обновлено: ${state.selectedCurrency.code} (${state.selectedCurrency.symbol})');
  }

  Future<void> setCurrencyByCode(String currencyCode) async {
    final currency = Currencies.getByCode(currencyCode);
    if (currency != null) {
      await setCurrency(currency);
    }
  }

  Future<void> setAccountName(String accountName) async {
    print('🔄 setAccountName вызван: $accountName');
    await _saveAccountNameToPrefs(accountName);
    print('💾 Имя счета сохранено в SharedPreferences: $accountName');
    emit(state.copyWith(accountName: accountName));
    print('📡 Состояние обновлено: ${state.accountName}');
  }

  Future<void> _saveCurrencyToPrefs(String code, String symbol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyCodeKey, code);
      await prefs.setString(_currencySymbolKey, symbol);
    } catch (e) {
      print('❌ Ошибка при сохранении валюты: $e');
    }
  }

  Future<void> _saveAccountNameToPrefs(String accountName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accountNameKey, accountName);
    } catch (e) {
      print('❌ Ошибка при сохранении имени счета: $e');
    }
  }
} 