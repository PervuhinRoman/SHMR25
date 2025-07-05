import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../models/chart_data.dart';
import '../config/chart_config.dart';

/// Виджет круговой диаграммы с легендой
class PieChartWidget extends StatefulWidget {
  /// Данные для отображения
  final List<ChartSection> sections;

  /// Конфигурация графика
  final PieChartConfig config;

  /// Callback при нажатии на секцию
  final void Function(ChartSection section)? onSectionTap;

  /// Callback при нажатии на элемент легенды
  final void Function(ChartSection section)? onLegendTap;

  const PieChartWidget({
    super.key,
    required this.sections,
    this.config = const PieChartConfig(),
    this.onSectionTap,
    this.onLegendTap,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  bool _isShowingTooltip = false;

  @override
  void initState() {
    super.initState();

    if (widget.config.enableAnimation) {
      _animationController = AnimationController(
        duration: widget.config.animationDuration,
        vsync: this,
      );

      _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0, 0.5, curve: Curves.easeOut),
        ),
      );

      _animationController.forward();
    }
  }

  @override
  void dispose() {
    if (widget.config.enableAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(PieChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Перезапускаем анимацию при изменении данных
    if (widget.config.enableAnimation &&
        oldWidget.sections != widget.sections) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  /// Генерирует цвет для секции
  Color _getColorForIndex(int index) {
    if (widget.config.customColors != null) {
      return widget
          .config.customColors![index % widget.config.customColors!.length];
    }

    // Генерируем детерминированный цвет на основе индекса
    final hue = (index * 360.0 / widget.sections.length) % 360.0;
    // Используем детерминированные значения для насыщенности и яркости
    final saturation = 0.7 + ((index * 0.3) % 0.3); // 70-100%
    final lightness = 0.4 + (((index * 7) % 30) / 100.0); // 40-70%

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  /// Показывает tooltip с информацией о секции
  void _showTooltip(ChartSection section) {
    if (!widget.config.enableTooltips || _isShowingTooltip) return;

    _isShowingTooltip = true;

    final formatter = widget.config.numberFormat != null
        ? NumberFormat(widget.config.numberFormat!, 'ru_RU')
        : NumberFormat('#,##0.00', 'ru_RU');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(section.emoji),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  section.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Сумма: ${formatter.format(section.value)} ₽',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Процент: ${section.percentage.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 14),
              ),
              if (section.additionalInfo != null) ...[
                const SizedBox(height: 8),
                Text(
                  section.additionalInfo!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    ).then((_) {
      _isShowingTooltip = false;
    });
  }

  /// Строит секции для графика
  List<PieChartSectionData> _buildSections() {
    return widget.sections.asMap().entries.map((entry) {
      final index = entry.key;
      final section = entry.value;

      log(
        "📊 Сектор $index: ${section.name} - ${section.value} (${section.percentage.toStringAsFixed(1)}%)",
        name: 'PieChart',
      );

      return PieChartSectionData(
        value: section.value,
        color: _getColorForIndex(index),
        radius: widget.config.sectionRadius,
        title: '',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: null,
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  /// Строит легенду
  Widget _buildLegend() {
    if (!widget.config.showLegend) return const SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.config.maxLegendWidth,
          maxHeight: widget.config.maxLegendHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget.config.legendRowSpacing,
              ),
              child: GestureDetector(
                onTap: () => widget.onLegendTap?.call(section),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Цветной кружок
                    Container(
                      width: widget.config.legendDotSize,
                      height: widget.config.legendDotSize,
                      decoration: BoxDecoration(
                        color: _getColorForIndex(index),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Процент и название
                    Flexible(
                      child: Text(
                        widget.config.showPercentages
                            ? '${section.percentage.toStringAsFixed(0)}% ${section.name}'
                            : section.name,
                        style: TextStyle(
                          fontSize: widget.config.legendFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Строит пустое состояние
  Widget _buildEmptyState() {
    return SizedBox(
      height: widget.config.size,
      width: widget.config.size,
      child: Stack(
        children: [
          Center(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 1,
                    color: Colors.grey[300]!,
                    radius: widget.config.sectionRadius,
                    title: '',
                  ),
                ],
                centerSpaceRadius: widget.config.centerSpaceRadius,
                sectionsSpace: 0,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart, size: 32, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Нет данных',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sections.isEmpty) {
      return _buildEmptyState();
    }

    if (!widget.config.enableAnimation) {
      return _buildChart();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final isNewContent = _animationController.value > 0.5;
        final fadeValue = isNewContent
            ? (_animationController.value - 0.5) * 2
            : 1 - (_animationController.value * 2);

        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: Opacity(
            opacity: fadeValue,
            child: _buildChart(),
          ),
        );
      },
    );
  }

  /// Строит основной график
  Widget _buildChart() {
    final sections = _buildSections();

    log("📊 Создано секторов: ${sections.length}", name: 'PieChart');

    return SizedBox(
      width: widget.config.size,
      height: widget.config.size,
      child: Stack(
        children: [
          Center(
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: widget.config.centerSpaceRadius,
                sectionsSpace: widget.config.sectionsSpace,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (event.isInterestedForInteractions &&
                        pieTouchResponse != null) {
                      final touchedSection = pieTouchResponse.touchedSection;
                      if (touchedSection != null &&
                          touchedSection.touchedSectionIndex >= 0 &&
                          touchedSection.touchedSectionIndex <
                              widget.sections.length) {
                        final section =
                            widget.sections[touchedSection.touchedSectionIndex];
                        widget.onSectionTap?.call(section);
                        _showTooltip(section);
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          _buildLegend(),
        ],
      ),
    );
  }
}
