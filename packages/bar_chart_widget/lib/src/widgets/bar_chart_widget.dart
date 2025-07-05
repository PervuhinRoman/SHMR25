import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../models/bar_data.dart';
import '../config/bar_config.dart';

/// Виджет столбчатой диаграммы
class BarChartWidget extends StatefulWidget {
  /// Данные для отображения
  final List<BarData> bars;

  /// Конфигурация графика
  final BarChartConfig config;

  /// Callback при нажатии на столбец
  final void Function(BarData bar)? onBarTap;

  const BarChartWidget({
    super.key,
    required this.bars,
    this.config = const BarChartConfig(),
    this.onBarTap,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isShowingTooltip = false;

  @override
  void initState() {
    super.initState();

    if (widget.config.enableAnimation) {
      _animationController = AnimationController(
        duration: widget.config.animationDuration,
        vsync: this,
      );

      _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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
  void didUpdateWidget(BarChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Перезапускаем анимацию при изменении данных
    if (widget.config.enableAnimation && oldWidget.bars != widget.bars) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  /// Показывает тултип с информацией о столбце
  void _showTooltip(BarData bar) {
    if (!widget.config.enableTooltips || _isShowingTooltip) return;

    _isShowingTooltip = true;

    final formatter = widget.config.numberFormat != null
        ? NumberFormat(widget.config.numberFormat!, 'ru_RU')
        : NumberFormat('#,##0.00', 'ru_RU');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Баланс за ${bar.formattedDate}'),
          content: Text(
            '${formatter.format(bar.value)} ₽',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(bar.color),
            ),
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

  /// Строит столбцы для графика
  List<BarChartGroupData> _buildBars() {
    return widget.bars.asMap().entries.map((entry) {
      final index = entry.key;
      final bar = entry.value;

      log(
        "📊 Столбец $index: ${bar.formattedDate} - ${bar.value}",
        name: 'BarChart',
      );

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: bar.value,
            color: Color(bar.color),
            width: widget.config.barWidth,
            borderRadius: BorderRadius.circular(widget.config.barRadius),
          ),
        ],
      );
    }).toList();
  }

  /// Строит подписи для оси X
  Widget _buildBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < widget.bars.length) {
      // Показываем подписи только через каждые 10 дней
      if (index % 10 == 0) {
        final bar = widget.bars[index];
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Transform.rotate(
            angle: -0.785398, // -45 градусов в радианах
            child: Text(
              bar.formattedDate,
              style: TextStyle(
                color: widget.config.textColor,
                fontSize: widget.config.labelFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }



  /// Строит пустое состояние
  Widget _buildEmptyState() {
    return SizedBox(
      height: widget.config.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нет данных',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bars.isEmpty) {
      return _buildEmptyState();
    }

    if (!widget.config.enableAnimation) {
      return _buildChart();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _buildChart();
      },
    );
  }

  /// Строит основной график
  Widget _buildChart() {
    final bars = _buildBars();
    final maxValue = widget.bars.fold<double>(
      0,
      (max, bar) => bar.value > max ? bar.value : max,
    );
    final minValue = widget.bars.fold<double>(
      0,
      (min, bar) => bar.value < min ? bar.value : min,
    );

    log("📊 Создано столбцов: ${bars.length}", name: 'BarChart');

    return SizedBox(
      height: widget.config.height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue > 0 ? maxValue * 1.1 : 0, // Минимальный отступ сверху
          minY: minValue < 0 ? minValue * 1.1 : 0, // Минимальный отступ снизу
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) => null, // Возвращаем null для отключения tooltip
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              // Обрабатываем только удержание (long press)
              if (event.runtimeType.toString().contains('LongPress') &&
                  barTouchResponse != null &&
                  barTouchResponse.spot != null) {
                final touchedIndex =
                    barTouchResponse.spot!.touchedBarGroupIndex;
                if (touchedIndex >= 0 && touchedIndex < widget.bars.length) {
                  final bar = widget.bars[touchedIndex];
                  widget.onBarTap?.call(bar);
                  _showTooltip(bar);
                }
              }
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _buildBottomTitles,
                reservedSize: 60, // Увеличиваем место для вертикальных подписей
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Скрываем ось Y
            ),
          ),
          borderData: FlBorderData(show: false), // Убираем границы
          gridData: FlGridData(show: false), // Убираем сетку
          barGroups: bars,
        ),
      ),
    );
  }
}
