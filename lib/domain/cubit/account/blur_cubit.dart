import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'blur_state.dart';

class BlurCubit extends Cubit<BlurState> {
  static const String _balanceVisibleKey = 'balance_visible';
  
  BlurCubit() : super(const BlurState(isBalanceVisible: true, isLoading: true)) {
    _loadBalanceVisibility();
  }

  /// Загружает состояние видимости баланса из SharedPreferences
  Future<void> _loadBalanceVisibility() async {
    try {
      log('📱 Загружаю состояние видимости баланса из SharedPreferences...', name: 'Blur');
      final prefs = await SharedPreferences.getInstance();
      final isVisible = prefs.getBool(_balanceVisibleKey) ?? true;
      log('📱 Загружено состояние баланса: ${isVisible ? "видимый" : "скрытый"}', name: 'Blur');
      emit(state.copyWith(isBalanceVisible: isVisible, isLoading: false));
    } catch (e) {
      log('❌ Ошибка при загрузке состояния видимости: $e', name: 'Blur');
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Сохраняет состояние видимости баланса в SharedPreferences
  Future<void> _saveBalanceVisibility() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_balanceVisibleKey, state.isBalanceVisible);
      log('💾 Сохранено состояние баланса: ${state.isBalanceVisible ? "видимый" : "скрытый"}', name: 'Blur');
    } catch (e) {
      log('❌ Ошибка при сохранении состояния видимости: $e', name: 'Blur');
    }
  }

  /// Переключает видимость баланса
  Future<void> toggleBalanceVisibility() async {
    log('🔄 Переключение видимости баланса', name: 'Blur');
    final newVisibility = !state.isBalanceVisible;
    emit(state.copyWith(isBalanceVisible: newVisibility));
    await _saveBalanceVisibility();
    log('📡 Состояние обновлено: ${newVisibility ? "показать" : "скрыть"}', name: 'Blur');
  }

  /// Устанавливает видимость баланса
  Future<void> setBalanceVisibility(bool isVisible) async {
    log('🔄 Установка видимости баланса: ${isVisible ? "показать" : "скрыть"}', name: 'Blur');
    emit(state.copyWith(isBalanceVisible: isVisible));
    await _saveBalanceVisibility();
    log('📡 Состояние обновлено: ${isVisible ? "показать" : "скрыть"}', name: 'Blur');
  }

  /// Показывает баланс
  Future<void> showBalance() async {
    await setBalanceVisibility(true);
  }

  /// Скрывает баланс
  Future<void> hideBalance() async {
    await setBalanceVisibility(false);
  }

  /// Обновляет состояние из внешнего источника (например, из сенсоров)
  void updateFromSensor(bool isVisible) {
    if (state.isBalanceVisible != isVisible) {
      log('🔄 Обновление из сенсора: ${isVisible ? "показать" : "скрыть"}', name: 'Blur');
      emit(state.copyWith(isBalanceVisible: isVisible));
      _saveBalanceVisibility();
    }
  }
} 