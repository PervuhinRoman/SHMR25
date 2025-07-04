import 'package:flutter_bloc/flutter_bloc.dart';

part 'datepicker_state.dart';

class DatePickerCubit extends Cubit<DatePickerState> {
  DatePickerCubit()
    : super(DatePickerState());

  void setStartDate(DateTime newStartDate) {
    DateTime? endDate = state.endDate;

    if (endDate != null && newStartDate.isAfter(endDate)) {
      endDate = newStartDate.copyWith(hour: 23, minute: 59);
    }

    final newState = state.copyWith(startDate: newStartDate, endDate: endDate);

    emit(newState);
  }

  void setEndDate(DateTime newEndDate) {
    DateTime? startDate = state.startDate;

    if (startDate != null && newEndDate.isBefore(startDate)) {
      startDate = newEndDate.copyWith(hour: 0, minute: 0);
    }

    final newState = state.copyWith(startDate: startDate, endDate: newEndDate.copyWith(hour: 23, minute: 59));

    emit(newState);
  }
}
