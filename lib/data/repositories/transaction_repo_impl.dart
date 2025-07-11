import 'dart:developer';

import 'package:shmr_finance/data/repositories/category_repo.dart';
import 'package:shmr_finance/data/repositories/transaction_repo.dart';
import 'package:shmr_finance/data/services/api_service.dart';

import '../../domain/models/account/account.dart';
import '../../domain/models/category/category.dart';
import '../../domain/models/transaction/transaction.dart';
import 'account_repo.dart';
import '../database/transaction_database.dart';
import 'package:drift/drift.dart';

class TransactionRepoImp implements TransactionRepository {
  final CategoryRepository _categoryRepo;
  final AccountRepository _accountRepo;
  final AppDatabase _transactionDatabase;
  final ApiService _apiService;
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
    ApiService? apiService,
  ]) : _transactionDatabase = transactionDatabase ?? AppDatabase.instance,
       _apiService = apiService ?? ApiService();

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
      
      // Используем API сервис вместо прямых вызовов DIO
      final responses = await _apiService.getPeriodTransactionsByAccount(
        accountId,
        startDate: startDate,
        endDate: endDate,
      );

      log(
        '📊 Получено транзакций: ${responses.length}',
        name: 'TransactionRepo',
      );

      // Сортировка по дате (новые сначала)
      responses.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

      return responses;
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
    try {
      return await _apiService.getTransaction(id);
    } catch (e) {
      log(
        '❌ Error in getTransaction: $e',
        name: 'TransactionRepo',
      );
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> createTransaction(
    TransactionRequest request,
  ) async {
    try {
      final transaction = await _apiService.createTransaction(request);
      // Преобразуем Transaction в TransactionResponse
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
    } catch (e) {
      log(
        '❌ Error in createTransaction: $e',
        name: 'TransactionRepo',
      );
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  ) async {
    try {
      return await _apiService.updateTransaction(id, request);
    } catch (e) {
      log(
        '❌ Error in updateTransaction: $e',
        name: 'TransactionRepo',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    try {
      await _apiService.deleteTransaction(id);
    } catch (e) {
      log(
        '❌ Error in deleteTransaction: $e',
        name: 'TransactionRepo',
      );
      rethrow;
    }
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
