part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final bool isIncome;
  const LoadTransactions(this.isIncome);

  @override
  List<Object?> get props => [isIncome];
}