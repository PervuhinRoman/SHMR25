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
    on<SelectStartDate>(_onSelectStartDate);
    on<SelectEndDate>(_onSelectEndDate);
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
        startDate: event.startDate,
        endDate: event.endDate,
      );

      final responses = rawResponses.where((response) =>
      response.category.isIncome == event.isIncome
      ).toList();

      emit(TransactionLoaded(
        responses,
        event.startDate,
        event.endDate,
      ));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onSelectStartDate(
    SelectStartDate event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      emit(TransactionLoaded(
        currentState.transactions,
        event.date,
        currentState.endDate,
      ));
    }
  }

  Future<void> _onSelectEndDate(
    SelectEndDate event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      emit(TransactionLoaded(
        currentState.transactions,
        currentState.startDate,
        event.date,
      ));
    }
  }
}