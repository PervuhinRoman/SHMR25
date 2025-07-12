import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

/// Интерцептор для реализации retry логики с exponential backoff
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay;
  final double multiplier;
  final Duration maxDelay;
  final bool enableJitter;
  final Set<int> retryableStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.multiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.enableJitter = true,
    Set<int>? retryableStatusCodes,
  }) : retryableStatusCodes = retryableStatusCodes ?? {
          408, // Request Timeout
          429, // Too Many Requests
          500, // Internal Server Error
          502, // Bad Gateway
          503, // Service Unavailable
          504, // Gateway Timeout
        };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Проверяем, нужно ли делать retry
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    // Получаем количество уже выполненных попыток
    final retryCount = _getRetryCount(err.requestOptions);
    
    if (retryCount >= maxRetries) {
      // Превышено максимальное количество попыток
      return handler.next(err);
    }

    // Вычисляем задержку с exponential backoff
    final delay = _calculateDelay(retryCount);
    
    // Проверяем Retry-After заголовок
    final retryAfterDelay = _getRetryAfterDelay(err.response);
    final finalDelay = retryAfterDelay ?? delay;

    // Ждем перед следующей попыткой
    await Future.delayed(finalDelay);

    // Увеличиваем счетчик попыток
    _incrementRetryCount(err.requestOptions);

    // Повторяем запрос
    try {
      final response = await _retryRequest(err.requestOptions);
      return handler.resolve(response);
    } catch (retryError) {
      // Если retry тоже не удался, передаем ошибку дальше
      return handler.next(retryError as DioException);
    }
  }

  /// Проверяет, нужно ли делать retry для данной ошибки
  bool _shouldRetry(DioException error) {
    // Проверяем код статуса
    if (error.response?.statusCode != null) {
      return retryableStatusCodes.contains(error.response!.statusCode);
    }

    // Проверяем тип ошибки
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      default:
        return false;
    }
  }

  /// Вычисляет задержку с exponential backoff
  Duration _calculateDelay(int retryCount) {
    // Базовый расчет: baseDelay * (multiplier ^ retryCount)
    final exponentialDelay = baseDelay.inMilliseconds * 
        (multiplier * retryCount).round();
    
    // Ограничиваем максимальной задержкой
    final cappedDelay = exponentialDelay > maxDelay.inMilliseconds 
        ? maxDelay.inMilliseconds 
        : exponentialDelay;

    // Добавляем jitter для избежания thundering herd
    if (enableJitter) {
      final jitter = Random().nextDouble() * 0.1; // ±10% jitter
      final jitteredDelay = cappedDelay * (1 + jitter);
      return Duration(milliseconds: jitteredDelay.round());
    }

    return Duration(milliseconds: cappedDelay);
  }

  /// Получает задержку из Retry-After заголовка
  Duration? _getRetryAfterDelay(Response? response) {
    if (response?.headers.value('retry-after') == null) {
      return null;
    }

    final retryAfter = response!.headers.value('retry-after')!;
    
    // Парсим Retry-After заголовок
    try {
      // Может быть число секунд или HTTP date
      final seconds = int.tryParse(retryAfter);
      if (seconds != null) {
        return Duration(seconds: seconds);
      }
      
      // Пытаемся парсить как HTTP date
      final date = DateTime.parse(retryAfter);
      final now = DateTime.now();
      final difference = date.difference(now);
      
      if (difference.isNegative) {
        return null; // Дата в прошлом
      }
      
      return difference;
    } catch (e) {
      // Если не удалось распарсить, возвращаем null
      return null;
    }
  }

  /// Получает количество уже выполненных попыток
  int _getRetryCount(RequestOptions options) {
    return options.extra['retry_count'] ?? 0;
  }

  /// Увеличивает счетчик попыток
  void _incrementRetryCount(RequestOptions options) {
    final currentCount = _getRetryCount(options);
    options.extra['retry_count'] = currentCount + 1;
  }

  /// Повторяет запрос
  Future<Response> _retryRequest(RequestOptions options) async {
    final dio = Dio();
    
    // Копируем опции запроса
    final requestOptions = RequestOptions(
      method: options.method,
      path: options.path,
      baseUrl: options.baseUrl,
      headers: options.headers,
      data: options.data,
      queryParameters: options.queryParameters,
      extra: options.extra,
      validateStatus: options.validateStatus,
    );

    return await dio.fetch(requestOptions);
  }
}

/// Расширение для Dio с удобными методами
extension DioRetryExtension on Dio {
  /// Добавляет retry интерцептор с настройками по умолчанию
  void addRetryInterceptor({
    int maxRetries = 3,
    Duration baseDelay = const Duration(seconds: 1),
    double multiplier = 2.0,
    Duration maxDelay = const Duration(seconds: 30),
    bool enableJitter = true,
    Set<int>? retryableStatusCodes,
  }) {
    interceptors.add(
      RetryInterceptor(
        maxRetries: maxRetries,
        baseDelay: baseDelay,
        multiplier: multiplier,
        maxDelay: maxDelay,
        enableJitter: enableJitter,
        retryableStatusCodes: retryableStatusCodes,
      ),
    );
  }
} 