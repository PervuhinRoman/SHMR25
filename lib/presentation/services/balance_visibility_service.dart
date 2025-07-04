import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shmr_finance/domain/cubit/account/blur_cubit.dart';

class BalanceVisibilityService {
  static const double threshold = 5.0;
  static const int _orientationDebounceTime = 1000;

  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  DateTime? _lastOrientationChange;
  BlurCubit? _blurCubit;

  // Инициализация сервиса
  Future<void> initialize(BlurCubit blurCubit) async {
    _blurCubit = blurCubit;
    _startListening();
    log('📱 BalanceVisibilityService инициализирован', name: 'Blur');
  }

  // Начало прослушивания сенсоров
  void _startListening() {
    _gyroscopeSubscription = gyroscopeEventStream().listen(_handleGyroscope);
  }

  // Обработка данных гироскопа (переворот)
  void _handleGyroscope(GyroscopeEvent event) {
    if (event.y.abs() > threshold || event.x.abs() > threshold) {
      final now = DateTime.now();

      if (_lastOrientationChange == null ||
          now.difference(_lastOrientationChange!).inMilliseconds >
              _orientationDebounceTime) {
        _lastOrientationChange = now;
        _toggleBalanceVisibility();
      }
    }
  }

  void _toggleBalanceVisibility() {
    if (_blurCubit != null) {
      _blurCubit!.toggleBalanceVisibility();

      // Вибрация для обратной связи
      HapticFeedback.mediumImpact();

      log('🔄 Переключение видимости баланса через сенсор', name: 'Blur');
    }
  }

  void dispose() {
    _gyroscopeSubscription?.cancel();
    _blurCubit = null;
  }
}
