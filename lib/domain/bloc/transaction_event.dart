part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final bool isIncome;
  final DateTime startDate;
  final DateTime endDate;
  
  const LoadTransactions(
    this.isIncome,
    this.startDate,
    this.endDate,
  );

  @override
  List<Object?> get props => [isIncome, startDate, endDate];
}

class SelectStartDate extends TransactionEvent {
  final DateTime date;
  const SelectStartDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectEndDate extends TransactionEvent {
  final DateTime date;
  const SelectEndDate(this.date);

  @override
  List<Object?> get props => [date];
}