part of 'blur_cubit.dart';

class BlurState {
  final bool isBalanceVisible;
  final bool isLoading;

  const BlurState({
    this.isBalanceVisible = true,
    this.isLoading = false,
  });

  BlurState copyWith({
    bool? isBalanceVisible,
    bool? isLoading,
  }) {
    return BlurState(
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
} 