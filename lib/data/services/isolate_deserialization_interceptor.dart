import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../domain/models/account/account.dart';
import '../../domain/models/category/category.dart';
import '../../domain/models/transaction/transaction.dart';

/// Интерцептор для десериализации ответов через пул изолятов
class IsolateDeserializationInterceptor extends Interceptor {
  static const int _threshold = 50 * 1024; // 50KB порог
  static const Duration _timeout = Duration(seconds: 5);

  // Критичные эндпоинты для использования изолятов
  static const Set<String> _criticalEndpoints = {
    '/transactions',
    '/transactions/account',
    '/categories',
    '/accounts',
  };

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      // Проверяем, нужно ли использовать изолят
      if (_shouldUseIsolate(response.requestOptions.path, response.data)) {
        final startTime = DateTime.now();

        // Десериализуем через изолят
        final deserializedData = await _deserializeInIsolate(response.data);

        final duration = DateTime.now().difference(startTime);
        _logPerformance(
          'Isolate deserialization',
          duration,
          response.data.toString().length,
        );

        // Создаем новый response с десериализованными данными
        final newResponse = Response(
          data: deserializedData,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          requestOptions: response.requestOptions,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
        );

        handler.next(newResponse);
      } else {
        // Используем обычную десериализацию
        handler.next(response);
      }
    } catch (e) {
      log(
        '❌ Error in isolate deserialization: $e',
        name: 'IsolateDeserializer',
      );
      // Fallback к обычной обработке
      handler.next(response);
    }
  }

  /// Проверяет, нужно ли использовать изолят для десериализации
  bool _shouldUseIsolate(String path, dynamic data) {
    // Проверяем критичные эндпоинты
    if (!_criticalEndpoints.any((endpoint) => path.contains(endpoint))) {
      return false;
    }

    // Проверяем размер данных
    if (data is String) {
      return data.length > _threshold;
    } else if (data is Map || data is List) {
      final jsonString = jsonEncode(data);
      return jsonString.length > _threshold;
    }

    return false;
  }

  /// Десериализует данные через изолят
  Future<dynamic> _deserializeInIsolate(dynamic data) async {
    try {
      final jsonString = data is String ? data : jsonEncode(data);

      // Определяем тип данных по структуре
      final dataType = _detectDataType(data);

      // Выполняем десериализацию в изоляте
      final result = await workerManager.execute(() {
        return _isolateDeserialize(jsonString, dataType);
      });

      return result;
    } catch (e) {
      log('❌ Isolate deserialization failed: $e', name: 'IsolateDeserializer');
      // Fallback к синхронной десериализации
      return _syncDeserialize(data);
    }
  }

  /// Определяет тип данных по структуре
  String _detectDataType(dynamic data) {
    if (data is List) {
      if (data.isNotEmpty) {
        final firstItem = data.first;
        if (firstItem is Map) {
          if (firstItem.containsKey('accountId') &&
              firstItem.containsKey('categoryId')) {
            return 'TransactionResponse';
          } else if (firstItem.containsKey('isIncome')) {
            return 'Category';
          } else if (firstItem.containsKey('balance') &&
              firstItem.containsKey('currency')) {
            return 'Account';
          }
        }
      }
      return 'List';
    } else if (data is Map) {
      if (data.containsKey('accountId') && data.containsKey('categoryId')) {
        return 'TransactionResponse';
      } else if (data.containsKey('isIncome')) {
        return 'Category';
      } else if (data.containsKey('balance') && data.containsKey('currency')) {
        return 'Account';
      }
    }
    return 'Unknown';
  }

  /// Десериализация в изоляте
  static dynamic _isolateDeserialize(String jsonString, String dataType) {
    try {
      final json = jsonDecode(jsonString);

      switch (dataType) {
        case 'TransactionResponse':
          if (json is List) {
            return json
                .map((item) => TransactionResponse.fromJson(item))
                .toList();
          } else {
            return TransactionResponse.fromJson(json);
          }
        case 'Category':
          if (json is List) {
            return json.map((item) => Category.fromJson(item)).toList();
          } else {
            return Category.fromJson(json);
          }
        case 'Account':
          if (json is List) {
            return json.map((item) => Account.fromJson(item)).toList();
          } else {
            return Account.fromJson(json);
          }
        default:
          return json;
      }
    } catch (e) {
      throw FormatException('Failed to deserialize $dataType: $e');
    }
  }

  /// Синхронная десериализация (fallback)
  dynamic _syncDeserialize(dynamic data) {
    try {
      if (data is String) {
        return jsonDecode(data);
      }
      return data;
    } catch (e) {
      log('❌ Sync deserialization failed: $e', name: 'IsolateDeserializer');
      return data;
    }
  }

  /// Логирование производительности
  void _logPerformance(String operation, Duration time, int dataSize) {
    if (time > const Duration(milliseconds: 100)) {
      log(
        '⏱️ $operation took ${time.inMilliseconds}ms for ${(dataSize / 1024).toStringAsFixed(1)}KB',
        name: 'IsolateDeserializer',
      );
    }
  }
}

/// Расширение для Dio с удобными методами
extension DioIsolateExtension on Dio {
  /// Добавляет интерцептор десериализации через изоляты
  void addIsolateDeserializationInterceptor() {
    interceptors.add(IsolateDeserializationInterceptor());
  }
}
