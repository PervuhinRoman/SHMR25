import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/data/services/preferences_service.dart';
import 'package:shmr_finance/domain/models/currency/currency.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(CurrencyState(selectedCurrency: Currencies.available.first, isLoading: true)) {
    _loadSelectedCurrency();
  }

  Future<void> _loadSelectedCurrency() async {
    try {
      print('📱 Загружаю валюту из SharedPreferences...');
      final currencyCode = await PreferencesService.getSelectedCurrency();
      print('📱 Получен код валюты: $currencyCode');
      final currency = Currencies.getByCode(currencyCode) ?? Currencies.available.first;
      print('📱 Найдена валюта: ${currency.code}');
      emit(state.copyWith(selectedCurrency: currency, isLoading: false));
      print('📡 Состояние обновлено после загрузки: ${state.selectedCurrency.code}');
    } catch (e) {
      print('❌ Ошибка при загрузке валюты: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> setCurrency(Currency currency) async {
    print('🔄 setCurrency вызван: ${currency.code} (${currency.symbol})');
    await PreferencesService.setSelectedCurrency(currency.code, currency.symbol);
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
} 