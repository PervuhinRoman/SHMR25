import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../domain/models/account/account.dart';
import '../../domain/models/category/category.dart';
import '../../domain/models/transaction/transaction.dart';

class ApiService {
  static const String _baseUrl = 'https://shmr-finance.ru/api/v1';
  static const String _authToken = 'Bearer BpSpdGeoNdjhGmR79DByflxf'; // TODO: Вынести в конфигурацию
  
  late final Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Authorization': _authToken,
        'Content-Type': 'application/json',
      },
    ));
    
    // Добавляем интерцептор для логирования
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => log(obj.toString(), name: 'API'),
    ));
  }

  // ==================== ACCOUNTS ====================
  
  /// Получить все счета пользователя
  Future<List<Account>> getAccounts() async {
    try {
      final response = await _dio.get('/accounts');
      final List<dynamic> data = response.data;
      return data.map((json) => Account.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioError(e, 'getAccounts');
      rethrow;
    }
  }

  /// Создать новый счет
  Future<Account> createAccount(AccountCreateRequest request) async {
    try {
      final response = await _dio.post(
        '/accounts',
        data: request.toJson(),
      );
      return Account.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e, 'createAccount');
      rethrow;
    }
  }

  /// Получить счет по ID
  Future<AccountResponse> getAccountById(int id) async {
    try {
      final response = await _dio.get('/accounts/$id');
      return AccountResponse.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e, 'getAccountById');
      rethrow;
    }
  }

  /// Обновить счет
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    try {
      final response = await _dio.put(
        '/accounts/$id',
        data: request.toJson(),
      );
      return Account.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e, 'updateAccount');
      rethrow;
    }
  }

  /// Удалить счет
  Future<void> deleteAccount(int id) async {
    try {
      await _dio.delete('/accounts/$id');
    } on DioException catch (e) {
      _handleDioError(e, 'deleteAccount');
      rethrow;
    }
  }

  /// Получить историю изменений счета
  Future<AccountHistoryResponse> getAccountHistory(int id) async {
    try {
      final response = await _dio.get('/accounts/$id/history');
      return AccountHistoryResponse.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e, 'getAccountHistory');
      rethrow;
    }
  }

  // ==================== CATEGORIES ====================
  
  /// Получить все категории
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioError(e, 'getCategories');
      rethrow;
    }
  }

  /// Получить категории по типу
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    try {
      final response = await _dio.get('/categories/type/$isIncome');
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioError(e, 'getCategoriesByType');
      rethrow;
    }
  }

  // ==================== TRANSACTIONS ====================
  
  /// Создать новую транзакцию
  Future<Transaction> createTransaction(TransactionRequest request) async {
    try {
      final response = await _dio.post(
        '/transactions',
        data: request.toJson(),
      );
      return Transaction.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e, 'createTransaction');
      rethrow;
    }
  }

  /// Получить транзакцию по ID
  Future<TransactionResponse> getTransaction(int id) async {
    try {
      final response = await _dio.get('/transactions/$id');
      return TransactionResponse.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e, 'getTransaction');
      rethrow;
    }
  }

  /// Обновить транзакцию
  Future<TransactionResponse> updateTransaction(int id, TransactionRequest request) async {
    try {
      final response = await _dio.put(
        '/transactions/$id',
        data: request.toJson(),
      );
      return TransactionResponse.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e, 'updateTransaction');
      rethrow;
    }
  }

  /// Удалить транзакцию
  Future<void> deleteTransaction(int id) async {
    try {
      await _dio.delete('/transactions/$id');
    } on DioException catch (e) {
      _handleDioError(e, 'deleteTransaction');
      rethrow;
    }
  }

  /// Получить транзакции по счету за период
  Future<List<TransactionResponse>> getPeriodTransactionsByAccount(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(startDate);
      }
      if (endDate != null) {
        queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(endDate);
      }

      final response = await _dio.get(
        '/transactions/account/$accountId/period',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => TransactionResponse.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioError(e, 'getPeriodTransactionsByAccount');
      rethrow;
    }
  }

  // ==================== ERROR HANDLING ====================
  
  void _handleDioError(DioException e, String methodName) {
    log(
      '❌ API Error in $methodName: ${e.type} - ${e.message}',
      name: 'ApiService',
    );
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Request timeout', e);
      case DioExceptionType.badResponse:
        _handleHttpError(e.response?.statusCode, e.response?.data, methodName);
        break;
      case DioExceptionType.cancel:
        throw RequestCancelledException('Request was cancelled', e);
      case DioExceptionType.connectionError:
        throw NetworkException('Network connection error', e);
      default:
        throw ApiException('Unknown API error', e);
    }
  }

  void _handleHttpError(int? statusCode, dynamic data, String methodName) {
    switch (statusCode) {
      case 400:
        throw BadRequestException('Bad request: $data', data);
      case 401:
        throw UnauthorizedException('Unauthorized access', data);
      case 404:
        throw NotFoundException('Resource not found', data);
      case 409:
        throw ConflictException('Resource conflict', data);
      case 500:
        throw ServerException('Internal server error', data);
      default:
        throw ApiException('HTTP error $statusCode: $data', data);
    }
  }
}

// ==================== CUSTOM EXCEPTIONS ====================

class ApiException implements Exception {
  final String message;
  final dynamic data;
  
  ApiException(this.message, [this.data]);
  
  @override
  String toString() => 'ApiException: $message';
}

class TimeoutException extends ApiException {
  TimeoutException(String message, [dynamic data]) : super(message, data);
}

class NetworkException extends ApiException {
  NetworkException(String message, [dynamic data]) : super(message, data);
}

class BadRequestException extends ApiException {
  BadRequestException(String message, [dynamic data]) : super(message, data);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, [dynamic data]) : super(message, data);
}

class NotFoundException extends ApiException {
  NotFoundException(String message, [dynamic data]) : super(message, data);
}

class ConflictException extends ApiException {
  ConflictException(String message, [dynamic data]) : super(message, data);
}

class ServerException extends ApiException {
  ServerException(String message, [dynamic data]) : super(message, data);
}

class RequestCancelledException extends ApiException {
  RequestCancelledException(String message, [dynamic data]) : super(message, data);
} 