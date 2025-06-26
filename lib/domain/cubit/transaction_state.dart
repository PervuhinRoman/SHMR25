part of 'transaction_cubit.dart';

enum TransactionStatus { loading, loaded, error }

class TransactionState {
  final List<TransactionResponse> transactions;
  final String? error;
  final TransactionStatus status;

  const TransactionState({
    required this.transactions,
    this.error,
    required this.status,
  });

  TransactionState copyWith({
    List<TransactionResponse>? transactions,
    String? error,
    TransactionStatus? status,
  }) => TransactionState(
    transactions: transactions ?? this.transactions,
    error: error ?? this.error,
    status: status ?? this.status,
  );
}
