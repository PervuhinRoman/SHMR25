part of 'account_cubit.dart';

class MyAccountState {
  final Currency selectedCurrency;
  final String accountName;
  final bool isLoading;

  const MyAccountState({
    required this.selectedCurrency,
    this.accountName = '',
    this.isLoading = false,
  });

  MyAccountState copyWith({
    Currency? selectedCurrency,
    String? accountName,
    bool? isLoading,
  }) {
    return MyAccountState(
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      accountName: accountName ?? this.accountName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
} 