import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blur_state.dart';

class BlurCubit extends Cubit<BlurState> {
  static const String _balanceVisibleKey = 'balance_visible';
  
  BlurCubit() : super(const BlurState(isBalanceVisible: true, isLoading: true)) {
    _loadBalanceVisibility();
  }

  /// Загружает состояние видимости баланса из SharedPreferences
  Future<void> _loadBalanceVisibility() async {
    try {
      print('📱 Загружаю состояние видимости баланса из SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      final isVisible = prefs.getBool(_balanceVisibleKey) ?? true;
      print('📱 Загружено состояние баланса: ${isVisible ? "видимый" : "скрытый"}');
      emit(state.copyWith(isBalanceVisible: isVisible, isLoading: false));
    } catch (e) {
      print('❌ Ошибка при загрузке состояния видимости: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Сохраняет состояние видимости баланса в SharedPreferences
  Future<void> _saveBalanceVisibility() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_balanceVisibleKey, state.isBalanceVisible);
      print('💾 Сохранено состояние баланса: ${state.isBalanceVisible ? "видимый" : "скрытый"}');
    } catch (e) {
      print('❌ Ошибка при сохранении состояния видимости: $e');
    }
  }

  /// Переключает видимость баланса
  Future<void> toggleBalanceVisibility() async {
    print('🔄 Переключение видимости баланса');
    final newVisibility = !state.isBalanceVisible;
    emit(state.copyWith(isBalanceVisible: newVisibility));
    await _saveBalanceVisibility();
    print('📡 Состояние обновлено: ${newVisibility ? "показать" : "скрыть"}');
  }

  /// Устанавливает видимость баланса
  Future<void> setBalanceVisibility(bool isVisible) async {
    print('🔄 Установка видимости баланса: ${isVisible ? "показать" : "скрыть"}');
    emit(state.copyWith(isBalanceVisible: isVisible));
    await _saveBalanceVisibility();
    print('📡 Состояние обновлено: ${isVisible ? "показать" : "скрыть"}');
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
      print('🔄 Обновление из сенсора: ${isVisible ? "показать" : "скрыть"}');
      emit(state.copyWith(isBalanceVisible: isVisible));
      _saveBalanceVisibility();
    }
  }
} 