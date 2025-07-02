import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:shmr_finance/domain/cubit/transactions/sort_type_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shmr_finance/domain/models/category/category.dart';
import 'package:shmr_finance/domain/models/category/combine_category.dart';

import 'package:shmr_finance/data/repositories/account_repo_impl.dart';
import 'package:shmr_finance/data/repositories/category_repo_impl.dart';
import 'package:shmr_finance/data/repositories/transaction_repo_impl.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit()
    : super(
        TransactionState(transactions: [], status: TransactionStatus.loading),
      );

  Future<void> fetchTransactions({
    DateTime? startDate,
    DateTime? endDate,
    required bool isIncome,
  }) async {
    print(
      '🎯 fetchTransactions вызван: isIncome=$isIncome, startDate=$startDate, endDate=$endDate',
    );
    // Проверка наличия соединения с интернетом
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult != ConnectivityResult.none;
    if (!hasInternet) {
      print('🌐 Интернет недоступен, загружаем из кэша');
      await fetchLocalTransactionsForPeriod(startDate, endDate, isIncome);
      return;
    }

    print('🌐 Интернет доступен, загружаем из сети');

    try {
      final AccountRepoImp accountRepo = AccountRepoImp();
      final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
      final TransactionRepoImp transactionRepo = TransactionRepoImp(
        accountRepo,
        categoryRepo,
      );

      print('📡 Выполняем сетевой запрос...');
      final List<TransactionResponse> rawResponses = await transactionRepo
          .getPeriodTransactionsByAccount(
            1, // TODO: захардкоженный аккаунт
            startDate: startDate,
            endDate: endDate,
          );
      print('📡 Получено из сети: ${rawResponses.length} транзакций');

      // Проверяем первые три транзакции перед фильтрацией
      for (int i = 0; i < rawResponses.length && i < 3; i++) {
        final response = rawResponses[i];
        print(
          '📊 Транзакция $i: id=${response.id}, amount=${response.amount}, category=${response.category.name}, isIncome=${response.category.isIncome}',
        );
      }

      final responses =
          rawResponses
              .where((response) => response.category.isIncome == isIncome)
              .toList();
      print(
        '📡 Отфильтровано по isIncome=$isIncome: ${responses.length} транзакций',
      );

      // Сохраняем транзакции в локальное хранилище за период
      if (startDate != null && endDate != null) {
        await transactionRepo.saveTransactionsForPeriod(
          rawResponses,
          startDate,
          endDate,
        );
      } else {
        // Fallback для сегодняшних транзакций (т.е. если null)
        final today = DateTime.now();
        final todayTransactions =
            rawResponses
                .where(
                  (response) =>
                      response.transactionDate.year == today.year &&
                      response.transactionDate.month == today.month &&
                      response.transactionDate.day == today.day,
                )
                .map(
                  (r) => Transaction(
                    id: r.id,
                    accountId: r.account.id,
                    categoryId: r.category.id,
                    amount: r.amount,
                    transactionDate: r.transactionDate,
                    comment: r.comment,
                    createdAt: r.createdAt,
                    updatedAt: r.updatedAt,
                  ),
                )
                .toList();
        await transactionRepo.saveTodayTransactions(todayTransactions);
      }
      print(
        '✅ Эмитим состояние: ${responses.length} транзакций, статус: loaded, источник: network',
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
      print('❌ Ошибка при загрузке из сети: $e');
      if (!isClosed) {
        emit(
          state.copyWith(error: e.toString(), status: TransactionStatus.error),
        );
      }
    }
  }

  Future<void> fetchLocalTransactions() async {
    print('📱 Загрузка локальных транзакций за сегодня');
    try {
      final AccountRepoImp accountRepo = AccountRepoImp();
      final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
      final TransactionRepoImp transactionRepo = TransactionRepoImp(
        accountRepo,
        categoryRepo,
      );
      final responses = await transactionRepo.getTodayTransactions();
      print('📱 Загружено из кэша за сегодня: ${responses.length} транзакций');
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
      print('❌ Ошибка при загрузке из кэша: $e');
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
      print('📱 Загрузка локальных транзакций за сегодня (fallback)');
      await fetchLocalTransactions();
      return;
    }
    print(
      '📱 Загрузка локальных транзакций за период ${startDate.toIso8601String().substring(0, 10)} - ${endDate.toIso8601String().substring(0, 10)}',
    );
    try {
      final AccountRepoImp accountRepo = AccountRepoImp();
      final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
      final TransactionRepoImp transactionRepo = TransactionRepoImp(
        accountRepo,
        categoryRepo,
      );
      final responses = await transactionRepo.getTransactionsForPeriod(
        startDate,
        endDate,
      );
      print('📱 Загружено из кэша за период: ${responses.length} транзакций');

      // Проверяем данные перед фильтрацией
      for (int i = 0; i < responses.length && i < 3; i++) {
        final response = responses[i];
        print(
          '📊 Кэш транзакция $i: id=${response.id}, amount=${response.amount}, category=${response.category.name}, isIncome=${response.category.isIncome}',
        );
      }

      final filteredResponses =
          responses
              .where((response) => response.category.isIncome == isIncome)
              .toList();
      print(
        '📱 Отфильтровано по isIncome=$isIncome: ${filteredResponses.length} транзакций',
      );

      // Проверяем отфильтрованные данные
      for (int i = 0; i < filteredResponses.length && i < 3; i++) {
        final response = filteredResponses[i];
        print(
          '✅ Отфильтрованная транзакция $i: id=${response.id}, amount=${response.amount}, category=${response.category.name}, isIncome=${response.category.isIncome}',
        );
      }

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
      print('❌ Ошибка при загрузке из кэша за период: $e');
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
}
