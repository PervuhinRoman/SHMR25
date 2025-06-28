import 'package:shmr_finance/data/repositories/category_repo.dart';
import 'package:shmr_finance/data/repositories/transaction_repo.dart';

import '../../domain/models/account/account.dart';
import '../../domain/models/category/category.dart';
import '../../domain/models/transaction/transaction.dart';
import 'account_repo.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../database/transaction_database.dart';

class TransactionRepoImp implements TransactionRepository {
  final CategoryRepository _categoryRepo;
  final AccountRepository _accountRepo;
  final TransactionDatabase _transactionDatabase;
  final List<Transaction> _transactions = [
    Transaction(
      id: 1,
      accountId: 1,
      categoryId: 1,
      amount: '50000.00',
      transactionDate: DateTime.now(),
      comment: 'Зарплата',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Transaction(
      id: 2,
      accountId: 1,
      categoryId: 2,
      amount: '1000.00',
      transactionDate: DateTime.now(),
      comment: 'Продукты',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  TransactionRepoImp(this._accountRepo, this._categoryRepo, [TransactionDatabase? transactionDatabase])
      : _transactionDatabase = transactionDatabase ?? TransactionDatabase.instance;

  // Метод для получения категории по ID
  Future<Category> _getCategoryById(int categoryId) async {
    final categories = await _categoryRepo.getAllCategories();
    return categories.firstWhere(
          (category) => category.id == categoryId,
      orElse: () => throw Exception('Category not found'),
    );
  }

  // Метод для получения информации о счете по ID
  Future<AccountBrief> _getAccountBriefById(int accountId) async {
    if (accountId == 0) {
      // Возвращаем дефолтный аккаунт для транзакций из кэша
      return AccountBrief(
        id: 1, // Используем ID 1 как дефолтный
        name: "Основной счет",
        balance: "0.00",
        currency: "RUB",
      );
    }
    final account = await _accountRepo.getAccountById(accountId);
    return AccountBrief(
      id: account.id,
      name: account.name,
      balance: account.balance,
      currency: account.currency,
    );
  }

  // Метод для преобразования Transaction в TransactionResponse
  Future<TransactionResponse> _toTransactionResponse(Transaction transaction) async {
    final category = await _getCategoryById(transaction.categoryId);
    final account = await _getAccountBriefById(transaction.accountId);

    return TransactionResponse(
      id: transaction.id,
      account: account,
      category: category,
      amount: transaction.amount,
      transactionDate: transaction.transactionDate,
      comment: transaction.comment,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }

  @override
  Future<List<TransactionResponse>> getPeriodTransactionsByAccount(
      int accountId, {
        DateTime? startDate,
        DateTime? endDate,
      }) async {
    try {
      print('🌐 Выполняю сетевой запрос для аккаунта $accountId, период: ${startDate?.toIso8601String().substring(0, 10)} - ${endDate?.toIso8601String().substring(0, 10)}');
      // TODO: Перенести работу DIO в Service
      final dio = Dio();
      final response = await dio.get(
        'https://shmr-finance.ru/api/v1/transactions/account/$accountId/period',
        queryParameters: {
          'startDate': DateFormat('yyyy-MM-dd').format(startDate!),
          'endDate': DateFormat('yyyy-MM-dd').format(endDate!),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer BpSpdGeoNdjhGmR79DByflxf',
          },
        ),
      );

      print('📡 Получен ответ от сервера: ${response.statusCode}');
      // Используем Freezed для десериализации
      final List<dynamic> rawData = response.data;
      print('📊 Сырых данных получено: ${rawData.length}');
      final List<TransactionResponse> responses = [];

      for (final item in rawData) {
        try {
          if (item is Map<String, dynamic>) {
            // Используем автоматически сгенерированный fromJson
            final transactionResponse = TransactionResponse.fromJson(item);
            
            // Проверяем, что транзакция принадлежит нужному аккаунту
            if (transactionResponse.account.id == accountId) {
              responses.add(transactionResponse);
            }
          }
        } catch (e) {
          print('Error parsing transaction: $e');
          continue;
        }
      }

      print('📊 После парсинга: ${responses.length} транзакций');
      // Фильтрация по датам
      var filteredResponses = responses;
      if (startDate != null) {
        final startOfDay = startDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
        filteredResponses = filteredResponses
            .where((t) => t.transactionDate.isAtSameMomentAs(startOfDay) || t.transactionDate.isAfter(startOfDay))
            .toList();
      }
      if (endDate != null) {
        final endOfDay = endDate.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
        filteredResponses = filteredResponses
            .where((t) => t.transactionDate.isAtSameMomentAs(endOfDay) || t.transactionDate.isBefore(endOfDay))
            .toList();
      }

      print('📊 После фильтрации по датам: ${filteredResponses.length} транзакций');
      return filteredResponses;
    } catch (e) {
      print('❌ Error in getPeriodTransactionsByAccount: $e');
      // Возвращаем пустой список в случае ошибки
      return [];
    }
  }

  @override
  Future<TransactionResponse> getTransaction(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final transaction = _transactions.firstWhere((t) => t.id == id);
    return _toTransactionResponse(transaction);
  }

  @override
  Future<TransactionResponse> createTransaction(TransactionRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newTransaction = Transaction(
      id: _transactions.length + 1,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _transactions.add(newTransaction);
    return _toTransactionResponse(newTransaction);
  }

  @override
  Future<TransactionResponse> updateTransaction(int id, TransactionRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception('Transaction not found'); // TODO: куда выкидывать ошибки потом...

    final updatedTransaction = Transaction(
      id: id,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment,
      createdAt: _transactions[index].createdAt,
      updatedAt: DateTime.now(),
    );

    _transactions[index] = updatedTransaction;
    return _toTransactionResponse(updatedTransaction);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions.removeWhere((t) => t.id == id);
  }

  // --- Локальное сохранение и получение транзакций за сегодня ---
  Future<void> saveTodayTransactions(List<Transaction> transactions) async {
    print('💾 Сохранение транзакций за сегодня в кэш: ${transactions.length} транзакций');
    await _transactionDatabase.clearTransactions();
    for (final t in transactions) {
      await _transactionDatabase.insertTransaction({
        'id': t.id.toString(),
        'amount': double.tryParse(t.amount) ?? 0.0,
        'category': t.categoryId.toString(),
        'date': t.transactionDate.toIso8601String().substring(0, 10),
        'note': t.comment ?? '',
      });
    }
    print('✅ Транзакции за сегодня успешно сохранены в кэш');
  }

  Future<List<TransactionResponse>> getTodayTransactions() async {
    final today = DateTime.now();
    final dateStr = today.toIso8601String().substring(0, 10);
    final maps = await _transactionDatabase.getTransactionsByDate(dateStr);
    final List<TransactionResponse> responses = [];
    for (final map in maps) {
      final transaction = Transaction(
        id: int.tryParse(map['id'].toString()) ?? 0,
        accountId: 0, // Можно доработать, если нужно
        categoryId: int.tryParse(map['category'].toString()) ?? 0,
        amount: map['amount'].toString(),
        transactionDate: DateTime.parse(map['date']),
        comment: map['note'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      try {
        final category = await _getCategoryById(transaction.categoryId);
        final account = await _getAccountBriefById(transaction.accountId);
        responses.add(TransactionResponse(
          id: transaction.id,
          account: account,
          category: category,
          amount: transaction.amount,
          transactionDate: transaction.transactionDate,
          comment: transaction.comment,
          createdAt: transaction.createdAt,
          updatedAt: transaction.updatedAt,
        ));
      } catch (_) {
        continue;
      }
    }
    return responses;
  }

  Future<void> saveTransactionsForPeriod(List<TransactionResponse> transactions, DateTime startDate, DateTime endDate) async {
    print('💾 Сохранение транзакций за период ${startDate.toIso8601String().substring(0, 10)} - ${endDate.toIso8601String().substring(0, 10)} в кэш: ${transactions.length} транзакций');
    final startDateStr = startDate.toIso8601String().substring(0, 10);
    final endDateStr = endDate.toIso8601String().substring(0, 10);
    final maps = transactions.map((t) => {
      'id': t.id.toString(),
      'amount': double.tryParse(t.amount) ?? 0.0,
      'category': t.category.id.toString(),
      'date': t.transactionDate.toIso8601String().substring(0, 10),
      'note': t.comment ?? '',
    }).toList();
    await _transactionDatabase.saveTransactionsForPeriod(maps, startDateStr, endDateStr);
    print('✅ Транзакции за период успешно сохранены в кэш');
  }

  Future<List<TransactionResponse>> getTransactionsForPeriod(DateTime startDate, DateTime endDate) async {
    final startDateStr = startDate.toIso8601String().substring(0, 10);
    final endDateStr = endDate.toIso8601String().substring(0, 10);
    final maps = await _transactionDatabase.getTransactionsByPeriod(startDateStr, endDateStr);
    print('📊 getTransactionsForPeriod: получено из БД ${maps.length} записей');
    
    final List<TransactionResponse> responses = [];
    for (int i = 0; i < maps.length; i++) {
      final map = maps[i];
      print('📊 Обрабатываю запись $i: $map');
      
      final transaction = Transaction(
        id: int.tryParse(map['id'].toString()) ?? 0,
        accountId: 0, // Можно доработать, если нужно
        categoryId: int.tryParse(map['category'].toString()) ?? 0,
        amount: map['amount'].toString(),
        transactionDate: DateTime.parse(map['date']),
        comment: map['note'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      print('📊 Создана транзакция: id=${transaction.id}, categoryId=${transaction.categoryId}, amount=${transaction.amount}');
      
      try {
        final category = await _getCategoryById(transaction.categoryId);
        print('📊 Получена категория: id=${category.id}, name=${category.name}, isIncome=${category.isIncome}');
        
        final account = await _getAccountBriefById(transaction.accountId);
        print('📊 Получен аккаунт: id=${account.id}, name=${account.name}');
        
        final response = TransactionResponse(
          id: transaction.id,
          account: account,
          category: category,
          amount: transaction.amount,
          transactionDate: transaction.transactionDate,
          comment: transaction.comment,
          createdAt: transaction.createdAt,
          updatedAt: transaction.updatedAt,
        );
        
        print('📊 Создан TransactionResponse: id=${response.id}, category=${response.category.name}, isIncome=${response.category.isIncome}');
        responses.add(response);
      } catch (e) {
        print('❌ Ошибка при обработке записи $i: $e');
        continue;
      }
    }
    
    print('📊 getTransactionsForPeriod: итого создано ${responses.length} TransactionResponse');
    return responses;
  }
}