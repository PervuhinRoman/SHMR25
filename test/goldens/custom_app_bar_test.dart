import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart'; // Укажите правильный путь

void main() {
  testWidgets('Golden test for CustomAppBar', (WidgetTester tester) async {
    // Создаем тестовое приложение с MaterialApp, так как AppBar требует Material контекст
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            title: 'Test Title',
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
          body: Container(),
        ),
      ),
    );

    // Ждем отрисовки виджета
    await tester.pump();

    // Сравниваем с golden-файлом
    await expectLater(
      find.byType(CustomAppBar),
      matchesGoldenFile('goldens/custom_app_bar.png'),
    );
  });

  testWidgets('Golden test for CustomAppBar with custom color', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(title: 'Colored Title', bgColor: Colors.red),
          body: Container(),
        ),
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(CustomAppBar),
      matchesGoldenFile('goldens/custom_app_bar_colored.png'),
    );
  });
}
