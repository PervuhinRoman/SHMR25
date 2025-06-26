part of 'datepicker_cubit.dart';

class DatePickerState {
  final DateTime? startDate;
  final DateTime? endDate;

  DatePickerState({
    DateTime? startDate,
    DateTime? endDate,
  }) : startDate = startDate ?? _getDefaultStartDate(),
       endDate = endDate ?? DateTime.now().copyWith(hour: 23, minute: 59);

  DatePickerState copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DatePickerState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  static DateTime _getDefaultStartDate() {
    final now = DateTime.now();
    // Обработка случая, когда текущий месяц - январь
    if (now.month == 1) {
      return DateTime(now.year - 1, 12, now.day, 0, 0, 0);
    } else {
      return DateTime(now.year, now.month - 1, now.day, 0, 0, 0);
    }
  }
}
