part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionResponse> transactions;
  final DateTime startDate;
  final DateTime endDate;
  
  const TransactionLoaded(
    this.transactions,
    this.startDate,
    this.endDate,
  );

  @override
  List<Object?> get props => [transactions, startDate, endDate];
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}