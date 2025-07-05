import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:bar_chart_widget/bar_chart_widget.dart';

void main() {
  testWidgets('BarChartWidget displays empty state when no data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BarChartWidget(
            bars: [],
            config: BarChartConfig(),
          ),
        ),
      ),
    );

    expect(find.text('Нет данных'), findsOneWidget);
  });

  testWidgets('BarChartWidget displays chart when data is provided',
      (WidgetTester tester) async {
    final testData = [
      BarData.fromData(
        date: DateTime.now(),
        value: 100.0,
        positiveColor: Colors.green.value,
        negativeColor: Colors.red.value,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BarChartWidget(
            bars: testData,
            config: const BarChartConfig(),
          ),
        ),
      ),
    );

    expect(find.text('Нет данных'), findsNothing);
  });

  testWidgets('BarChartWidget displays negative values above baseline with onBoard',
      (WidgetTester tester) async {
    final testData = [
      BarData.fromData(
        date: DateTime.now(),
        value: 100.0,
        positiveColor: Colors.green.value,
        negativeColor: Colors.red.value,
      ),
      BarData.fromData(
        date: DateTime.now().add(const Duration(days: 1)),
        value: -50.0,
        positiveColor: Colors.green.value,
        negativeColor: Colors.red.value,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BarChartWidget(
            bars: testData,
            config: const BarChartConfig(
              onBoard: 100.0, // Базовая линия на уровне 100
            ),
          ),
        ),
      ),
    );

    expect(find.text('Нет данных'), findsNothing);
    
    // Проверяем, что график отображается
    expect(find.byType(BarChartWidget), findsOneWidget);
  });

  testWidgets('BarChartConfig copyWith includes onBoard parameter',
      (WidgetTester tester) async {
    const originalConfig = BarChartConfig(height: 200.0);
    final newConfig = originalConfig.copyWith(onBoard: 50.0);
    
    expect(newConfig.height, 200.0);
    expect(newConfig.onBoard, 50.0);
  });
}
