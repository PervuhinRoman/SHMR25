import 'dart:developer';

import 'package:shmr_finance/data/repositories/category_repo.dart';
import 'package:shmr_finance/data/repositories/transaction_repo.dart';

import '../../domain/models/account/account.dart';
import '../../domain/models/category/category.dart';
import '../../domain/models/transaction/transaction.dart';
import 'account_repo.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../database/transaction_database.dart';
import 'package:drift/drift.dart';

class TransactionRepoImp implements TransactionRepository {
  final CategoryRepository _categoryRepo;
  final AccountRepository _accountRepo;
  final AppDatabase _transactionDatabase;
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

  TransactionRepoImp(
    this._accountRepo,
    this._categoryRepo, [
    AppDatabase? transactionDatabase,
  ]) : _transactionDatabase = transactionDatabase ?? AppDatabase.instance;

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
  Future<TransactionResponse> _toTransactionResponse(
    Transaction transaction,
  ) async {
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
      log(
        '🌐 Выполняем сетевой запрос для аккаунта $accountId, период: ${startDate?.toIso8601String().substring(0, 10)} - ${endDate?.toIso8601String().substring(0, 10)}',
        name: 'TransactionRepo',
      );
      // TODO: Перенести работу DIO в Service
      final dio = Dio();
      final response = await dio.get(
        'https://shmr-finance.ru/api/v1/transactions/account/$accountId/period',
        queryParameters: {
          'startDate': DateFormat('yyyy-MM-dd').format(startDate!),
          'endDate': DateFormat('yyyy-MM-dd').format(endDate!),
        },
        options: Options(
          headers: {'Authorization': 'Bearer BpSpdGeoNdjhGmR79DByflxf'},
        ),
      );

      log(
        '📡 Получен ответ от сервера: ${response.statusCode}',
        name: 'TransactionRepo',
      );

      // Используем Freezed для десериализации
      final List<dynamic> rawData = response.data;
      log(
        '📊 Сырых данных получено: ${rawData.length}',
        name: 'TransactionRepo',
      );
      final List<TransactionResponse> responses = [];

      for (final item in rawData) {
        try {
          if (item is Map<String, dynamic>) {
            // Используем автоматически сгенерированный fromJson
            final transactionResponse = TransactionResponse.fromJson(item);
            responses.add(transactionResponse);

            // Проверяем, что транзакция принадлежит нужному аккаунту
            // TODO: убрать / изменить, когда будем работать с реальным аккаунтом
            // if (transactionResponse.account.id == accountId) {
            //   responses.add(transactionResponse);
            // }
          }
        } catch (e) {
          log('❗ Ошибка при парсинге: $e', name: 'TransactionRepo');
          continue;
        }
      }

      log(
        '📊 После парсинга: ${responses.length} транзакций',
        name: 'TransactionRepo',
      );

      // Фильтрация и сортировка по датам
      var filteredSortedResponses = responses;
      final startOfDay = startDate.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      filteredSortedResponses =
          filteredSortedResponses
              .where(
                (t) =>
                    t.transactionDate.isAtSameMomentAs(startOfDay) ||
                    t.transactionDate.isAfter(startOfDay),
              )
              .toList();
      final endOfDay = endDate.copyWith(
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      );
      filteredSortedResponses =
          filteredSortedResponses
              .where(
                (t) =>
                    t.transactionDate.isAtSameMomentAs(endOfDay) ||
                    t.transactionDate.isBefore(endOfDay),
              )
              .toList();

      log(
        '📊 После фильтрации по датам: ${filteredSortedResponses.length} транзакций',
        name: 'TransactionRepo',
      );

      filteredSortedResponses.sort(
        (a, b) => b.transactionDate.compareTo(a.transactionDate),
      );

      return filteredSortedResponses;
    } catch (e) {
      log(
        '❌ Error in getPeriodTransactionsByAccount: $e',
        name: 'TransactionRepo',
      );
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
  Future<TransactionResponse> createTransaction(
    TransactionRequest request,
  ) async {
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
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _transactions.indexWhere((t) => t.id == id);

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

  /// Сохранение транзакций за период
  Future<void> saveTransactionsForPeriodDrift(
    List<TransactionResponse> transactions,
    DateTime startDate,
    DateTime endDate,
    AppDatabase db,
  ) async {
    await db.deleteTransactionsByPeriod(startDate, endDate);

    final transactionsData = <Insertable<TransactionResponseDBData>>[];
    final accountsData = <Insertable<AccountBriefDBData>>[];
    final categoriesData = <Insertable<CategoryDBData>>[];

    for (final t in transactions) {
      accountsData.add(
        AccountBriefDBCompanion(
          id: Value(t.account.id),
          name: Value(t.account.name),
          balance: Value(t.account.balance),
          currency: Value(t.account.currency),
        ),
      );
      categoriesData.add(
        CategoryDBCompanion(
          id: Value(t.category.id),
          name: Value(t.category.name),
          emoji: Value(t.category.emoji),
          isIncome: Value(t.category.isIncome),
        ),
      );
      transactionsData.add(
        TransactionResponseDBCompanion(
          id: Value(t.id),
          accountId: Value(t.account.id),
          categoryId: Value(t.category.id),
          amount: Value(t.amount),
          transactionDate: Value(t.transactionDate),
          comment: Value(t.comment),
          createdAt: Value(t.createdAt),
          updatedAt: Value(t.updatedAt),
        ),
      );
    }
    await db.insertTransactionResponses(
      transactionsData,
      accountsData,
      categoriesData,
    );
  }

  /// Получение транзакций за период
  Future<List<TransactionResponse>> getTransactionsForPeriodDrift(
    DateTime startDate,
    DateTime endDate,
    AppDatabase db,
  ) async {
    final transactionResponses = await db.getTransactionsByPeriod(
      startDate,
      endDate,
    );
    final result = <TransactionResponse>[];
    for (final t in transactionResponses) {
      // Получаем связанные аккаунт и категорию
      final account =
          await (db.select(db.accountBriefDB)
            ..where((a) => a.id.equals(t.accountId))).getSingle();
      final category =
          await (db.select(db.categoryDB)
            ..where((c) => c.id.equals(t.categoryId))).getSingle();
      result.add(
        TransactionResponse(
          id: t.id,
          account: AccountBrief(
            id: account.id,
            name: account.name,
            balance: account.balance,
            currency: account.currency,
          ),
          category: Category(
            id: category.id,
            name: category.name,
            emoji: category.emoji,
            isIncome: category.isIncome,
          ),
          amount: t.amount,
          transactionDate: t.transactionDate,
          comment: t.comment,
          createdAt: t.createdAt,
          updatedAt: t.updatedAt,
        ),
      );
    }
    return result;
  }
}
