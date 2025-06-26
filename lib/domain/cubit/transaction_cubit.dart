

import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import '../../data/repositories/account_repo_imp.dart';
import '../../data/repositories/category_repo_imp.dart';
import '../../data/repositories/transaction_repo_imp.dart';
import '../models/transaction/transaction.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit()
    : super(
        TransactionState(transactions: [], status: TransactionStatus.loading),
      );

  final AccountRepoImp accountRepo = AccountRepoImp();
  final CategoryRepoImpl categoryRepo = CategoryRepoImpl();

  Future<void> fetchTransactions({
    DateTime? startDate,
    DateTime? endDate,
    required bool isIncome,
  }) async {
    try {
      final AccountRepoImp accountRepo = AccountRepoImp();
      final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
      final TransactionRepoImp transactionRepo = TransactionRepoImp(
        accountRepo,
        categoryRepo,
      );

      final List<TransactionResponse> rawResponses = await transactionRepo
          .getPeriodTransactionsByAccount(
            1,
            startDate: startDate,
            endDate: endDate,
          );

      final responses =
          rawResponses
              .where((response) => response.category.isIncome == isIncome)
              .toList();

      emit(state.copyWith(transactions: responses, status: TransactionStatus.loaded));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), status: TransactionStatus.error));
    }
  }
}
