import 'package:intl/intl.dart';

/// Модель данных для столбца диаграммы
class BarData {
  /// Дата (для отображения на оси X)
  final DateTime date;
  
  /// Значение столбца (баланс за день/месяц)
  final double value;
  
  /// Форматированная дата для отображения
  final String formattedDate;
  
  /// Цвет столбца (зависит от значения)
  final int color;

  const BarData({
    required this.date,
    required this.value,
    required this.formattedDate,
    required this.color,
  });

  /// Создает BarData из даты и значения с автоматическим форматированием
  factory BarData.fromData({
    required DateTime date,
    required double value,
    required int positiveColor,
    required int negativeColor,
    String? dateFormat,
  }) {
    final formatter = dateFormat != null 
        ? DateFormat(dateFormat)
        : DateFormat('dd.MM');
    
    return BarData(
      date: date,
      value: value,
      formattedDate: formatter.format(date),
      color: value >= 0 ? positiveColor : negativeColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarData &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          value == other.value;

  @override
  int get hashCode => date.hashCode ^ value.hashCode;

  @override
  String toString() {
    return 'BarData{date: $formattedDate, value: $value}';
  }
} 