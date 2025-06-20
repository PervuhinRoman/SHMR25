import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';
import 'package:shmr_finance/data/repositories/transaction_repo_imp.dart';
import 'package:shmr_finance/data/repositories/account_repo_imp.dart';
import 'package:shmr_finance/data/repositories/category_repo_imp.dart';

import 'package:equatable/equatable.dart';

part 'transaction_state.dart';
part 'transaction_event.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());
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
        startDate: DateTime(2025, DateTime.june, 20),
        endDate: DateTime(2025, DateTime.june, 21),
      );

      final responses = rawResponses.where((response) =>
      response.category.isIncome == event.isIncome
      ).toList();

      emit(TransactionLoaded(responses));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}