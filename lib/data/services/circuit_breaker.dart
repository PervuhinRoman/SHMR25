import 'dart:async';
import 'dart:developer';

/// Состояния Circuit Breaker
enum CircuitBreakerState {
  closed,   // Нормальная работа
  open,     // Разомкнут - запросы блокируются
  halfOpen, // Полуоткрыт - тестируем восстановление
}

/// Circuit Breaker для защиты от каскадных ошибок
class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;
  
  CircuitBreakerState _state = CircuitBreakerState.closed;
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  Timer? _resetTimer;

  CircuitBreaker({
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 60),
    this.resetTimeout = const Duration(seconds: 30),
  });

  /// Проверяет, можно ли выполнить запрос
  bool get canExecute => _state != CircuitBreakerState.open;

  /// Получает текущее состояние
  CircuitBreakerState get state => _state;

  /// Выполняет функцию с защитой Circuit Breaker
  Future<T> execute<T>(Future<T> Function() function) async {
    if (!canExecute) {
      throw CircuitBreakerOpenException('Circuit breaker is open');
    }

    try {
      final result = await function();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }

  /// Обработка успешного выполнения
  void _onSuccess() {
    _failureCount = 0;
    _lastFailureTime = null;
    
    if (_state == CircuitBreakerState.halfOpen) {
      _close();
    }
  }

  /// Обработка ошибки
  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();

    if (_state == CircuitBreakerState.halfOpen) {
      _open();
    } else if (_state == CircuitBreakerState.closed && 
               _failureCount >= failureThreshold) {
      _open();
    }
  }

  /// Открывает Circuit Breaker
  void _open() {
    _state = CircuitBreakerState.open;
    log('🔴 Circuit Breaker opened after $_failureCount failures', name: 'CircuitBreaker');
    
    // Устанавливаем таймер для перехода в half-open состояние
    _resetTimer?.cancel();
    _resetTimer = Timer(resetTimeout, () {
      _halfOpen();
    });
  }

  /// Переводит Circuit Breaker в half-open состояние
  void _halfOpen() {
    _state = CircuitBreakerState.halfOpen;
    log('🟡 Circuit Breaker half-open - testing recovery', name: 'CircuitBreaker');
  }

  /// Закрывает Circuit Breaker
  void _close() {
    _state = CircuitBreakerState.closed;
    _failureCount = 0;
    _lastFailureTime = null;
    _resetTimer?.cancel();
    log('🟢 Circuit Breaker closed', name: 'CircuitBreaker');
  }

  /// Принудительно сбрасывает Circuit Breaker
  void reset() {
    _close();
  }

  /// Получает статистику
  Map<String, dynamic> get stats => {
    'state': _state.toString(),
    'failureCount': _failureCount,
    'lastFailureTime': _lastFailureTime?.toIso8601String(),
    'canExecute': canExecute,
  };

  /// Освобождает ресурсы
  void dispose() {
    _resetTimer?.cancel();
  }
}

/// Исключение для открытого Circuit Breaker
class CircuitBreakerOpenException implements Exception {
  final String message;
  
  CircuitBreakerOpenException(this.message);
  
  @override
  String toString() => 'CircuitBreakerOpenException: $message';
}

/// Менеджер Circuit Breaker для разных эндпоинтов
class CircuitBreakerManager {
  final Map<String, CircuitBreaker> _breakers = {};
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;

  CircuitBreakerManager({
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 60),
    this.resetTimeout = const Duration(seconds: 30),
  });

  /// Получает или создает Circuit Breaker для эндпоинта
  CircuitBreaker getBreaker(String endpoint) {
    return _breakers.putIfAbsent(endpoint, () => CircuitBreaker(
      failureThreshold: failureThreshold,
      timeout: timeout,
      resetTimeout: resetTimeout,
    ));
  }

  /// Выполняет запрос с Circuit Breaker для конкретного эндпоинта
  Future<T> execute<T>(String endpoint, Future<T> Function() function) async {
    final breaker = getBreaker(endpoint);
    return await breaker.execute(function);
  }

  /// Сбрасывает все Circuit Breaker
  void resetAll() {
    for (final breaker in _breakers.values) {
      breaker.reset();
    }
  }

  /// Получает статистику всех Circuit Breaker
  Map<String, Map<String, dynamic>> getStats() {
    return _breakers.map((endpoint, breaker) => 
      MapEntry(endpoint, breaker.stats));
  }

  /// Освобождает ресурсы
  void dispose() {
    for (final breaker in _breakers.values) {
      breaker.dispose();
    }
    _breakers.clear();
  }
} 