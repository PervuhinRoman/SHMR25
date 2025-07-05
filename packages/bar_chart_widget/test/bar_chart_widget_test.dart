import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:bar_chart_widget/bar_chart_widget.dart';

void main() {
  testWidgets('BarChartWidget displays empty state when no data', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BarChartWidget(
            bars: [],
            config: const BarChartConfig(),
          ),
        ),
      ),
    );

    expect(find.text('Нет данных'), findsOneWidget);
  });

  testWidgets('BarChartWidget displays chart when data is provided', (WidgetTester tester) async {
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
}
