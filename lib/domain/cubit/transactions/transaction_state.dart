part of 'transaction_cubit.dart';

enum TransactionStatus { loading, loaded, error }

enum DataSource { network, cache }

class TransactionState {
  final List<TransactionResponse> transactions;
  final List<Category> transactionsCategories;
  final List<CombineCategory> combineCategories;
  final String? error;
  final TransactionStatus status;
  final DataSource? dataSource;
  final bool isIncome;

  const TransactionState({
    required this.transactions,
    this.transactionsCategories = const [],
    this.combineCategories = const [],
    this.error,
    required this.status,
    this.dataSource,
    this.isIncome = false,
  });

  TransactionState copyWith({
    List<TransactionResponse>? transactions,
    List<Category>? transactionsCategories,
    List<CombineCategory>? combineCategories,
    String? error,
    TransactionStatus? status,
    DataSource? dataSource,
    bool? isIncome,
  }) => TransactionState(
    transactions: transactions ?? this.transactions,
    transactionsCategories: transactionsCategories ?? this.transactionsCategories,
    combineCategories: combineCategories ?? this.combineCategories,
    error: error ?? this.error,
    status: status ?? this.status,
    dataSource: dataSource ?? this.dataSource,
    isIncome: isIncome ?? this.isIncome,
  );
}
