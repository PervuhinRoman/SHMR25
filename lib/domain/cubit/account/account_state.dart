part of 'account_cubit.dart';

class MyAccountState {
  final Currency selectedCurrency;
  final String accountName;
  final bool isLoading;
  final int? accountId;

  const MyAccountState({
    required this.selectedCurrency,
    this.accountName = '',
    this.isLoading = false,
    this.accountId,
  });

  MyAccountState copyWith({
    Currency? selectedCurrency,
    String? accountName,
    bool? isLoading,
    int? accountId,
  }) {
    return MyAccountState(
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      accountName: accountName ?? this.accountName,
      isLoading: isLoading ?? this.isLoading,
      accountId: accountId ?? this.accountId,
    );
  }
} 