part of 'transaction_cubit.dart';

enum TransactionStatus { loading, loaded, error }

enum DataSource { network, cache }

class TransactionState {
  final List<TransactionResponse> transactions;
  final String? error;
  final TransactionStatus status;
  final DataSource? dataSource;

  const TransactionState({
    required this.transactions,
    this.error,
    required this.status,
    this.dataSource,
  });

  TransactionState copyWith({
    List<TransactionResponse>? transactions,
    String? error,
    TransactionStatus? status,
    DataSource? dataSource,
  }) => TransactionState(
    transactions: transactions ?? this.transactions,
    error: error ?? this.error,
    status: status ?? this.status,
    dataSource: dataSource ?? this.dataSource,
  );
}
