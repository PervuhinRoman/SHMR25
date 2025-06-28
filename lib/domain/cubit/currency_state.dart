part of 'currency_cubit.dart';

class CurrencyState {
  final Currency selectedCurrency;
  final bool isLoading;

  const CurrencyState({
    required this.selectedCurrency,
    this.isLoading = false,
  });

  CurrencyState copyWith({
    Currency? selectedCurrency,
    bool? isLoading,
  }) {
    return CurrencyState(
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isLoading: isLoading ?? this.isLoading,
    );
  }
} 