import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppBlurService {
  static const String _blurEnabledKey = 'app_blur_enabled';
  
  static final AppBlurService _instance = AppBlurService._internal();
  factory AppBlurService() => _instance;
  AppBlurService._internal();
  
  bool _isBlurEnabled = true;
  bool _isAppInBackground = false;
  VoidCallback? _onBlurStateChanged;
  
  bool get isBlurEnabled => _isBlurEnabled;
  bool get isAppInBackground => _isAppInBackground;
  
  // Инициализация сервиса
  Future<void> initialize() async {
    await _loadSettings();
    log('📱 AppBlurService инициализирован', name: 'AppBlur');
    log('  - isBlurEnabled: $_isBlurEnabled', name: 'AppBlur');
  }
  
  // Загрузка настроек
  Future<void> _loadSettings() async {
    // В будущем можно добавить SharedPreferences для сохранения настроек
    _isBlurEnabled = true; // По умолчанию включен
  }
  
  // Установка callback для уведомления об изменении состояния блюра
  void setBlurStateCallback(VoidCallback callback) {
    _onBlurStateChanged = callback;
  }
  
  // Включение/выключение блюра
  Future<void> setBlurEnabled(bool enabled) async {
    if (_isBlurEnabled != enabled) {
      _isBlurEnabled = enabled;
      log('🔒 App blur enabled: $enabled', name: 'AppBlur');
      
      // Если приложение в фоне и блюр включен, применяем его
      if (_isAppInBackground && _isBlurEnabled) {
        _applyBlur();
      } else if (!_isBlurEnabled) {
        _removeBlur();
      }
      
      _onBlurStateChanged?.call();
    }
  }
  
  // Обработка изменения состояния приложения
  void handleAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _handleAppBackground();
        break;
      case AppLifecycleState.resumed:
        _handleAppForeground();
        break;
      case AppLifecycleState.detached:
        // Приложение полностью закрыто
        break;
      case AppLifecycleState.hidden:
        // Приложение скрыто (например, переключение на другое приложение)
        _handleAppBackground();
        break;
    }
  }
  
  // Обработка перехода приложения в фон
  void _handleAppBackground() {
    if (_isAppInBackground) return; // Уже в фоне
    
    _isAppInBackground = true;
    log('📱 Приложение перешло в фон', name: 'AppBlur');
    
    if (_isBlurEnabled) {
      _applyBlur();
    }
  }
  
  // Обработка возврата приложения на передний план
  void _handleAppForeground() {
    if (!_isAppInBackground) return; // Уже на переднем плане
    
    _isAppInBackground = false;
    log('📱 Приложение вернулось на передний план', name: 'AppBlur');
    
    _removeBlur();
  }
  
  // Применение блюра
  void _applyBlur() {
    if (!_isBlurEnabled) return;
    
    try {
      log('🔒 Блюр применен', name: 'AppBlur');
      _onBlurStateChanged?.call();
      
      // Хаптик фидбек для подтверждения
      HapticFeedback.lightImpact();
    } catch (e) {
      log('❌ Ошибка применения блюра: $e', name: 'AppBlur');
    }
  }
  
  // Удаление блюра
  void _removeBlur() {
    try {
      log('🔓 Блюр удален', name: 'AppBlur');
      _onBlurStateChanged?.call();
    } catch (e) {
      log('❌ Ошибка удаления блюра: $e', name: 'AppBlur');
    }
  }
  
  // Принудительное применение блюра (для тестирования)
  void forceApplyBlur() {
    if (_isBlurEnabled) {
      _applyBlur();
    }
  }
  
  // Принудительное удаление блюра (для тестирования)
  void forceRemoveBlur() {
    _removeBlur();
  }
  
  // Получение текущего состояния
  Map<String, dynamic> getCurrentState() {
    return {
      'isBlurEnabled': _isBlurEnabled,
      'isAppInBackground': _isAppInBackground,
      'shouldShowBlur': _isBlurEnabled && _isAppInBackground,
    };
  }
  
  // Очистка ресурсов
  void dispose() {
    _onBlurStateChanged = null;
    log('📱 AppBlurService очищен', name: 'AppBlur');
  }
} 