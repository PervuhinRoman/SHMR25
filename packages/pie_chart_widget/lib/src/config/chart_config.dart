import 'package:flutter/material.dart';

/// Конфигурация для круговой диаграммы
class PieChartConfig {
  /// Размер графика
  final double size;
  
  /// Толщина секций (радиус)
  final double sectionRadius;
  
  /// Радиус центрального пространства для легенды
  final double centerSpaceRadius;
  
  /// Расстояние между секциями
  final double sectionsSpace;
  
  /// Размер цветных кружков в легенде
  final double legendDotSize;
  
  /// Размер шрифта в легенде
  final double legendFontSize;
  
  /// Максимальная ширина легенды
  final double maxLegendWidth;
  
  /// Максимальная высота легенды
  final double maxLegendHeight;
  
  /// Отступ между строками в легенде
  final double legendRowSpacing;
  
  /// Цвета для секций (если не указаны, генерируются автоматически)
  final List<Color>? customColors;
  
  /// Показывать ли анимацию
  final bool enableAnimation;
  
  /// Длительность анимации
  final Duration animationDuration;
  
  /// Показывать ли тултипы при нажатии
  final bool enableTooltips;
  
  /// Показывать ли легенду
  final bool showLegend;
  
  /// Показывать ли проценты в легенде
  final bool showPercentages;
  
  /// Форматирование чисел
  final String? numberFormat;

  const PieChartConfig({
    this.size = 300.0,
    this.sectionRadius = 16.0,
    this.centerSpaceRadius = 100.0,
    this.sectionsSpace = 2.0,
    this.legendDotSize = 12.0,
    this.legendFontSize = 12.0,
    this.maxLegendWidth = 180.0,
    this.maxLegendHeight = 180.0,
    this.legendRowSpacing = 1.0,
    this.customColors,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.enableTooltips = true,
    this.showLegend = true,
    this.showPercentages = true,
    this.numberFormat,
  });

  /// Создает конфигурацию по умолчанию для маленького графика
  factory PieChartConfig.small() {
    return const PieChartConfig(
      size: 200.0,
      sectionRadius: 16.0,
      centerSpaceRadius: 60.0,
      legendDotSize: 8.0,
      legendFontSize: 8.0,
      maxLegendWidth: 100.0,
      maxLegendHeight: 100.0,
    );
  }

  /// Создает конфигурацию по умолчанию для большого графика
  factory PieChartConfig.large() {
    return const PieChartConfig(
      size: 400.0,
      sectionRadius: 20.0,
      centerSpaceRadius: 120.0,
      legendDotSize: 16.0,
      legendFontSize: 14.0,
      maxLegendWidth: 240.0,
      maxLegendHeight: 240.0,
    );
  }

  /// Копирует конфигурацию с изменениями
  PieChartConfig copyWith({
    double? size,
    double? sectionRadius,
    double? centerSpaceRadius,
    double? sectionsSpace,
    double? legendDotSize,
    double? legendFontSize,
    double? maxLegendWidth,
    double? maxLegendHeight,
    double? legendRowSpacing,
    List<Color>? customColors,
    bool? enableAnimation,
    Duration? animationDuration,
    bool? enableTooltips,
    bool? showLegend,
    bool? showPercentages,
    String? numberFormat,
  }) {
    return PieChartConfig(
      size: size ?? this.size,
      sectionRadius: sectionRadius ?? this.sectionRadius,
      centerSpaceRadius: centerSpaceRadius ?? this.centerSpaceRadius,
      sectionsSpace: sectionsSpace ?? this.sectionsSpace,
      legendDotSize: legendDotSize ?? this.legendDotSize,
      legendFontSize: legendFontSize ?? this.legendFontSize,
      maxLegendWidth: maxLegendWidth ?? this.maxLegendWidth,
      maxLegendHeight: maxLegendHeight ?? this.maxLegendHeight,
      legendRowSpacing: legendRowSpacing ?? this.legendRowSpacing,
      customColors: customColors ?? this.customColors,
      enableAnimation: enableAnimation ?? this.enableAnimation,
      animationDuration: animationDuration ?? this.animationDuration,
      enableTooltips: enableTooltips ?? this.enableTooltips,
      showLegend: showLegend ?? this.showLegend,
      showPercentages: showPercentages ?? this.showPercentages,
      numberFormat: numberFormat ?? this.numberFormat,
    );
  }
} 