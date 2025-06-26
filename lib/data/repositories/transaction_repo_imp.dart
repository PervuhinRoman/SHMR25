import 'package:shmr_finance/data/repositories/category_repo.dart';
import 'package:shmr_finance/data/repositories/transaction_repo.dart';

import '../../domain/models/account/account.dart';
import '../../domain/models/category/category.dart';
import '../../domain/models/transaction/transaction.dart';
import 'account_repo.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class TransactionRepoImp implements TransactionRepository {
  final CategoryRepository _categoryRepo;
  final AccountRepository _accountRepo;
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

  TransactionRepoImp(this._accountRepo, this._categoryRepo);

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

      // Используем Freezed для десериализации
      final List<dynamic> rawData = response.data;
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

      // Фильтрация по датам
      var filteredResponses = responses;
      if (startDate != null) {
        filteredResponses = filteredResponses
            .where((t) => t.transactionDate.isAfter(startDate))
            .toList();
      }
      if (endDate != null) {
        filteredResponses = filteredResponses
            .where((t) => t.transactionDate.isBefore(endDate))
            .toList();
      }

      return filteredResponses;
    } catch (e) {
      print('Error in getPeriodTransactionsByAccount: $e');
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
}