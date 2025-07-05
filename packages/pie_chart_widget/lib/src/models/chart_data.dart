/// Модель данных для секции круговой диаграммы
class ChartSection {
  /// Уникальный идентификатор секции
  final String id;
  
  /// Название секции (категории)
  final String name;
  
  /// Эмодзи или иконка для секции
  final String emoji;
  
  /// Значение секции (сумма)
  final double value;
  
  /// Процент от общего значения
  final double percentage;
  
  /// Дополнительная информация (например, последняя транзакция)
  final String? additionalInfo;

  const ChartSection({
    required this.id,
    required this.name,
    required this.emoji,
    required this.value,
    required this.percentage,
    this.additionalInfo,
  });

  /// Создает ChartSection из данных с автоматическим расчетом процента
  factory ChartSection.fromData({
    required String id,
    required String name,
    required String emoji,
    required double value,
    required double totalValue,
    String? additionalInfo,
  }) {
    final percentage = totalValue > 0 ? (value * 100 / totalValue) : 0.0;
    
    return ChartSection(
      id: id,
      name: name,
      emoji: emoji,
      value: value,
      percentage: percentage,
      additionalInfo: additionalInfo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartSection &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChartSection{id: $id, name: $name, value: $value, percentage: ${percentage.toStringAsFixed(1)}%}';
  }
} 