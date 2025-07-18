import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:shmr_finance/domain/cubit/transactions/sort_type_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shmr_finance/domain/models/category/category.dart';
import 'package:shmr_finance/domain/models/category/combine_category.dart';

import 'package:shmr_finance/data/repositories/account_repo_impl.dart';
import 'package:shmr_finance/data/repositories/category_repo_impl.dart';
import 'package:shmr_finance/data/repositories/transaction_repo_impl.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';
import 'package:shmr_finance/data/database/transaction_database.dart';
import 'package:shmr_finance/data/services/transaction_sync_service.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit()
    : super(
        TransactionState(transactions: [], status: TransactionStatus.loading),
      ) {
    // Подписка на изменения статуса сети
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _syncDiffsWithStatus();
      }
    });
  }

  Future<void> fetchTransactions({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
    required bool isIncome,
  }) async {
    log(
      '🎯 fetchTransactions вызван: isIncome=$isIncome, startDate=$startDate, endDate=$endDate, accountId=$accountId',
      name: 'Transaction',
    );
    // Проверка наличия соединения с интернетом
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult != ConnectivityResult.none;
    if (!hasInternet) {
      log('🌐 Интернет недоступен, загружаем из кэша', name: 'Transaction');
      await fetchLocalTransactionsForPeriod(startDate, endDate, isIncome);
      return;
    }

    log('🌐 Интернет доступен, загружаем из сети', name: 'Transaction');

    try {
      final AccountRepoImp accountRepo = AccountRepoImp();
      final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
      final TransactionRepoImp transactionRepo = TransactionRepoImp(
        accountRepo,
        categoryRepo,
      );

      log('📡 Выполняем сетевой запрос...', name: 'Transaction');
      final List<TransactionResponse> rawResponses = await transactionRepo
          .getPeriodTransactionsByAccount(
            accountId,
            startDate: startDate,
            endDate: endDate,
          );
      log(
        '📡 Получено из сети: ${rawResponses.length} транзакций',
        name: 'Transaction',
      );

      // Проверяем первые три транзакции перед фильтрацией
      for (int i = 0; i < rawResponses.length && i < 3; i++) {
        final response = rawResponses[i];
        log(
          '📊 Транзакция $i: id=${response.id}, amount=${response.amount}, category=${response.category.name}, isIncome=${response.category.isIncome}',
          name: 'Transaction',
        );
      }

      final responses =
          rawResponses
              .where((response) => response.category.isIncome == isIncome)
              .toList();
      log(
        '📡 Отфильтровано по isIncome=$isIncome: ${responses.length} транзакций',
        name: 'Transaction',
      );

      // Сохраняем транзакции в локальное хранилище за период
      if (startDate != null && endDate != null) {
        await transactionRepo.saveTransactionsForPeriodDrift(
          rawResponses,
          startDate,
          endDate,
          AppDatabase.instance,
        );
      } // else-блок с todayTransactions можно закомментировать или удалить, если не нужен
      log(
        '✅ Эмитим состояние: ${responses.length} транзакций, статус: loaded, источник: network',
        name: 'Transaction',
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            transactions: responses,
            status: TransactionStatus.loaded,
            dataSource: DataSource.network,
            isIncome: isIncome,
          ),
        );
        _updateCategoriesFromTransactions();
      }
    } catch (e) {
      log('❌ Ошибка при загрузке из сети: $e', name: 'Transaction');
      if (!isClosed) {
        emit(
          state.copyWith(error: e.toString(), status: TransactionStatus.error),
        );
      }
    }
  }

  Future<void> fetchLocalTransactions() async {
    log('📱 Загрузка локальных транзакций за сегодня', name: 'Transaction');
    try {
      final AccountRepoImp accountRepo = AccountRepoImp();
      final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
      final TransactionRepoImp transactionRepo = TransactionRepoImp(
        accountRepo,
        categoryRepo,
      );
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day, 0, 0, 0);
      final endOfDay = DateTime(
        today.year,
        today.month,
        today.day,
        23,
        59,
        59,
        999,
      );
      final responses = await transactionRepo.getTransactionsForPeriodDrift(
        startOfDay,
        endOfDay,
        AppDatabase.instance,
      );
      log(
        '📱 Загружено из кэша за сегодня: ${responses.length} транзакций',
        name: 'Transaction',
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            transactions: responses,
            status: TransactionStatus.loaded,
            dataSource: DataSource.cache,
          ),
        );
        _updateCategoriesFromTransactions();
      }
    } catch (e) {
      log('❌ Ошибка при загрузке из кэша: $e', name: 'Transaction');
      if (!isClosed) {
        emit(
          state.copyWith(
            transactions: [],
            status: TransactionStatus.error,
            error: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> fetchLocalTransactionsForPeriod(
    DateTime? startDate,
    DateTime? endDate,
    bool isIncome,
  ) async {
    if (startDate == null || endDate == null) {
      log(
        '📱 Загрузка локальных транзакций за сегодня (fallback)',
        name: 'Transaction',
      );
      await fetchLocalTransactions();
      return;
    }
    log(
      '📱 Загрузка локальных транзакций за период ${startDate.toIso8601String().substring(0, 10)} - ${endDate.toIso8601String().substring(0, 10)}',
      name: 'Transaction',
    );
    try {
      final AccountRepoImp accountRepo = AccountRepoImp();
      final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
      final TransactionRepoImp transactionRepo = TransactionRepoImp(
        accountRepo,
        categoryRepo,
      );
      final responses = await transactionRepo.getTransactionsForPeriodDrift(
        startDate,
        endDate,
        AppDatabase.instance,
      );
      log(
        '📱 Загружено из кэша за период: ${responses.length} транзакций',
        name: 'Transaction',
      );

      final filteredResponses =
          responses
              .where((response) => response.category.isIncome == isIncome)
              .toList();
      log(
        '📱 Отфильтровано по isIncome=$isIncome: ${filteredResponses.length} транзакций',
        name: 'Transaction',
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            transactions: filteredResponses,
            status: TransactionStatus.loaded,
            dataSource: DataSource.cache,
            isIncome: isIncome,
          ),
        );
        _updateCategoriesFromTransactions();
      }
    } catch (e) {
      log('❌ Ошибка при загрузке из кэша за период: $e', name: 'Transaction');
      if (!isClosed) {
        emit(
          state.copyWith(
            transactions: [],
            status: TransactionStatus.error,
            error: e.toString(),
          ),
        );
      }
    }
  }

  void sort(SortType sortType) {
    final sortedTransactions = List<TransactionResponse>.from(
      state.transactions,
    );

    sortedTransactions.sort((a, b) {
      switch (sortType) {
        case SortType.date:
          return b.transactionDate.compareTo(a.transactionDate);
        case SortType.amount:
          return double.parse(b.amount).compareTo(double.parse(a.amount));
      }
    });

    if (!isClosed) {
      emit(state.copyWith(transactions: sortedTransactions));
      _updateCategoriesFromTransactions();
    }
  }

  void _updateCategoriesFromTransactions() {
    if (!isClosed) {
      // Сначала фильтруем по isIncome
      final filtered =
          state.transactions
              .where((t) => t.category.isIncome == state.isIncome)
              .toList();

      // Группируем по категории
      final Map<int, List<TransactionResponse>> grouped = {};
      for (final t in filtered) {
        grouped.putIfAbsent(t.category.id, () => []).add(t);
      }

      final combineCategories =
          grouped.entries.map((entry) {
            final category = entry.value.first.category;
            final totalAmount = entry.value.fold<double>(
              0,
              (sum, t) => sum + (double.tryParse(t.amount) ?? 0),
            );
            final lastTransaction =
                entry.value.isNotEmpty
                    ? entry.value.reduce(
                      (a, b) =>
                          a.transactionDate.isAfter(b.transactionDate) ? a : b,
                    )
                    : null;
            return CombineCategory(
              category: category,
              totalAmount: totalAmount,
              lastTransaction: lastTransaction,
            );
          }).toList();

      emit(state.copyWith(combineCategories: combineCategories));
    }
  }

  void _syncDiffsWithStatus() async {
    emit(state.copyWith(syncStatus: SyncStatus.syncing));
    try {
      await TransactionSyncService().syncPendingDiffs();
      emit(state.copyWith(syncStatus: SyncStatus.success));
    } catch (e) {
      emit(state.copyWith(syncStatus: SyncStatus.error));
    }
  }

  Future<void> createTransaction(TransactionRequest request) async {
    log('TransactionCubit: createTransaction вызван', name: 'TransactionCubit');
    try {
      final accountRepo = AccountRepoImp();
      final categoryRepo = CategoryRepoImpl();
      final transactionRepo = TransactionRepoImp(accountRepo, categoryRepo);
      await transactionRepo.createTransaction(request);
      log('TransactionCubit: транзакция успешно создана', name: 'TransactionCubit');
      // Можно обновить список транзакций, если нужно
      // await fetchTransactions(...);
    } catch (e) {
      log('TransactionCubit: ошибка при создании транзакции: $e', name: 'TransactionCubit');
      rethrow;
    }
  }

  Future<void> updateTransaction(int id, TransactionRequest request) async {
    log('TransactionCubit: updateTransaction вызван', name: 'TransactionCubit');
    try {
      final accountRepo = AccountRepoImp();
      final categoryRepo = CategoryRepoImpl();
      final transactionRepo = TransactionRepoImp(accountRepo, categoryRepo);
      await transactionRepo.updateTransaction(id, request);
      log('TransactionCubit: транзакция успешно обновлена', name: 'TransactionCubit');
      // Можно обновить список транзакций, если нужно
      // await fetchTransactions(...);
    } catch (e) {
      log('TransactionCubit: ошибка при обновлении транзакции: $e', name: 'TransactionCubit');
      rethrow;
    }
  }

  Future<void> deleteTransaction(int id) async {
    log('TransactionCubit: deleteTransaction вызван', name: 'TransactionCubit');
    try {
      final accountRepo = AccountRepoImp();
      final categoryRepo = CategoryRepoImpl();
      final transactionRepo = TransactionRepoImp(accountRepo, categoryRepo);
      await transactionRepo.deleteTransaction(id);
      log('TransactionCubit: транзакция успешно удалена', name: 'TransactionCubit');
      // Можно обновить список транзакций, если нужно
      // await fetchTransactions(...);
    } catch (e) {
      log('TransactionCubit: ошибка при удалении транзакции: $e', name: 'TransactionCubit');
      rethrow;
    }
  }
}
