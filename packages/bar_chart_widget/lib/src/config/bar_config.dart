import 'package:flutter/material.dart';

/// Конфигурация для столбчатой диаграммы
class BarChartConfig {
  /// Высота графика
  final double height;
  
  /// Ширина столбцов
  final double barWidth;
  
  /// Радиус закругления столбцов
  final double barRadius;
  
  /// Отступы графика
  final EdgeInsets padding;
  
  /// Цвет положительных значений
  final Color positiveColor;
  
  /// Цвет отрицательных значений
  final Color negativeColor;
  
  /// Цвет сетки
  final Color gridColor;
  
  /// Цвет текста осей
  final Color textColor;
  
  /// Размер шрифта для подписей
  final double labelFontSize;
  
  /// Показывать ли сетку
  final bool showGrid;
  
  /// Показывать ли тултипы
  final bool enableTooltips;
  
  /// Формат чисел
  final String? numberFormat;
  
  /// Формат дат
  final String? dateFormat;
  
  /// Показывать ли анимацию
  final bool enableAnimation;
  
  /// Длительность анимации
  final Duration animationDuration;

  /// Базовая линия для отображения столбцов (все столбцы отображаются выше этой линии)
  /// Если null, автоматически рассчитывается на основе минимального значения
  final double? onBoard;

  const BarChartConfig({
    this.height = 300.0,
    this.barWidth = 20.0,
    this.barRadius = 4.0,
    this.padding = const EdgeInsets.all(16.0),
    this.positiveColor = Colors.green,
    this.negativeColor = Colors.red,
    this.gridColor = Colors.grey,
    this.textColor = Colors.black87,
    this.labelFontSize = 12.0,
    this.showGrid = true,
    this.enableTooltips = true,
    this.numberFormat,
    this.dateFormat,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.onBoard,
  });

  /// Создает конфигурацию по умолчанию для маленького графика
  factory BarChartConfig.small() {
    return const BarChartConfig(
      height: 200.0,
      barWidth: 16.0,
      labelFontSize: 10.0,
    );
  }

  /// Создает конфигурацию по умолчанию для большого графика
  factory BarChartConfig.large() {
    return const BarChartConfig(
      height: 400.0,
      barWidth: 24.0,
      labelFontSize: 14.0,
    );
  }

  /// Копирует конфигурацию с изменениями
  BarChartConfig copyWith({
    double? height,
    double? barWidth,
    double? barRadius,
    EdgeInsets? padding,
    Color? positiveColor,
    Color? negativeColor,
    Color? gridColor,
    Color? textColor,
    double? labelFontSize,
    bool? showGrid,
    bool? enableTooltips,
    String? numberFormat,
    String? dateFormat,
    bool? enableAnimation,
    Duration? animationDuration,
    double? onBoard,
  }) {
    return BarChartConfig(
      height: height ?? this.height,
      barWidth: barWidth ?? this.barWidth,
      barRadius: barRadius ?? this.barRadius,
      padding: padding ?? this.padding,
      positiveColor: positiveColor ?? this.positiveColor,
      negativeColor: negativeColor ?? this.negativeColor,
      gridColor: gridColor ?? this.gridColor,
      textColor: textColor ?? this.textColor,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      showGrid: showGrid ?? this.showGrid,
      enableTooltips: enableTooltips ?? this.enableTooltips,
      numberFormat: numberFormat ?? this.numberFormat,
      dateFormat: dateFormat ?? this.dateFormat,
      enableAnimation: enableAnimation ?? this.enableAnimation,
      animationDuration: animationDuration ?? this.animationDuration,
      onBoard: onBoard ?? this.onBoard,
    );
  }
} 