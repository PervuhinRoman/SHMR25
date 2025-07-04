import 'package:flutter_bloc/flutter_bloc.dart';

enum SortType { date, amount }

class SortTypeState {
  SortType sortType;

  SortTypeState({required this.sortType});

  SortTypeState copyWith({SortType? sortType}) {
    return SortTypeState(sortType: sortType ?? this.sortType);
  }
}

class SortTypeCubit extends Cubit<SortTypeState> {
  SortTypeCubit() : super(SortTypeState(sortType: SortType.date));

  void changeSortType(SortType type) {
    emit(state.copyWith(sortType: type));
  }
}