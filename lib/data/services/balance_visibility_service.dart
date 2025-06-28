import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shmr_finance/domain/cubit/blur_cubit.dart';

class BalanceVisibilityService {
  // Пороги для определения тряски (увеличены для меньшей чувствительности)
  static const double _shakeThreshold = 25.0; // было 15.0
  static const int _shakeTimeWindow = 800; // миллисекунды (было 500)
  
  // Пороги для определения переворота (уменьшены для меньшей чувствительности)
  static const double _upsideDownThreshold = -0.9; // z-ось (было -0.8)
  static const int _orientationDebounceTime = 2000; // миллисекунды для предотвращения частых срабатываний
  
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  
  List<DateTime> _shakeEvents = [];
  DateTime? _lastOrientationChange;
  BlurCubit? _blurCubit;
  
  // Инициализация сервиса
  Future<void> initialize(BlurCubit blurCubit) async {
    _blurCubit = blurCubit;
    _startListening();
    print('📱 BalanceVisibilityService инициализирован');
  }
  
  // Начало прослушивания сенсоров
  void _startListening() {
    _accelerometerSubscription = accelerometerEvents.listen(_handleAccelerometer);
    _gyroscopeSubscription = gyroscopeEvents.listen(_handleGyroscope);
  }
  
  // Обработка данных акселерометра (тряска)
  void _handleAccelerometer(AccelerometerEvent event) {
    final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    
    if (magnitude > _shakeThreshold) {
      _shakeEvents.add(DateTime.now());
      
      // Удаляем старые события тряски
      _shakeEvents.removeWhere((time) => 
        DateTime.now().difference(time).inMilliseconds > _shakeTimeWindow);
      
      // Если достаточно событий тряски в окне времени (увеличено количество)
      if (_shakeEvents.length >= 4) { // было 3
        _toggleBalanceVisibility();
        _shakeEvents.clear();
      }
    }
  }
  
  // Обработка данных гироскопа (переворот)
  void _handleGyroscope(GyroscopeEvent event) {
    // Проверяем переворот устройства (z-ось) с защитой от частых срабатываний
    if (event.z < _upsideDownThreshold) {
      final now = DateTime.now();
      
      // Проверяем, прошло ли достаточно времени с последнего срабатывания
      if (_lastOrientationChange == null || 
          now.difference(_lastOrientationChange!).inMilliseconds > _orientationDebounceTime) {
        _lastOrientationChange = now;
        _toggleBalanceVisibility();
      }
    }
  }
  
  // Переключение видимости баланса
  void _toggleBalanceVisibility() {
    if (_blurCubit != null) {
      _blurCubit!.toggleBalanceVisibility();
      
      // Вибрация для обратной связи
      HapticFeedback.lightImpact();
      
      print('🔄 Переключение видимости баланса через сенсор');
    }
  }
  
  // Очистка ресурсов
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _blurCubit = null;
  }
} 