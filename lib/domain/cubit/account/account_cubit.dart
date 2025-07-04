import 'dart:developer';

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
      log('📱 Загружаю данные аккаунта из SharedPreferences...', name: "Валюта");
      final prefs = await SharedPreferences.getInstance();
      
      // Загружаем валюту
      final currencyCode = prefs.getString(_currencyCodeKey);
      final currencySymbol = prefs.getString(_currencySymbolKey);
      log('📱 Получен код валюты: $currencyCode, символ: $currencySymbol', name: "Валюта");
      
      Currency currency;
      if (currencyCode != null) {
        currency = Currencies.getByCode(currencyCode) ?? Currencies.available.first;
      } else {
        currency = Currencies.available.first;
      }
      log('📱 Найдена валюта: ${currency.code}', name: "Валюта");
      
      // Загружаем имя счета
      final accountName = prefs.getString(_accountNameKey) ?? 'Мой счёт';
      log('📱 Загружено имя счета: $accountName', name: "Имя счёта");
      
      emit(state.copyWith(
        selectedCurrency: currency,
        accountName: accountName,
        isLoading: false,
      ));
      log('📡 Состояние обновлено после загрузки: ${state.selectedCurrency.code}, ${state.accountName}');
    } catch (e) {
      log('❌ Ошибка при загрузке данных аккаунта: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> setCurrency(Currency currency) async {
    log('🔄 setCurrency вызван: ${currency.code} (${currency.symbol})', name: "Валюта");
    await _saveCurrencyToPrefs(currency.code, currency.symbol);
    log('💾 Валюта сохранена в SharedPreferences: ${currency.code} (${currency.symbol})', name: "Валюта");
    emit(state.copyWith(selectedCurrency: currency));
    log('📡 Состояние обновлено: ${state.selectedCurrency.code} (${state.selectedCurrency.symbol})', name: "Валюта");
  }

  Future<void> setCurrencyByCode(String currencyCode) async {
    final currency = Currencies.getByCode(currencyCode);
    if (currency != null) {
      await setCurrency(currency);
    }
  }

  Future<void> setAccountName(String accountName) async {
    log('🔄 setAccountName вызван: $accountName', name: "Имя счёта");
    await _saveAccountNameToPrefs(accountName);
    log('💾 Имя счета сохранено в SharedPreferences: $accountName', name: "Имя счёта");
    emit(state.copyWith(accountName: accountName));
    log('📡 Состояние обновлено: ${state.accountName}', name: "Имя счёта");
  }

  Future<void> _saveCurrencyToPrefs(String code, String symbol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyCodeKey, code);
      await prefs.setString(_currencySymbolKey, symbol);
    } catch (e) {
      log('❌ Ошибка при сохранении валюты: $e', name: "Валюта");
    }
  }

  Future<void> _saveAccountNameToPrefs(String accountName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accountNameKey, accountName);
    } catch (e) {
      log('❌ Ошибка при сохранении имени счета: $e', name: "Валюта");
    }
  }
} 