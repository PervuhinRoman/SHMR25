import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';

void main() {
  goldenTest(
    'CustomAppBar - default and colored',
    fileName: 'goldens/custom_app_bar_alchemy',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'Default CustomAppBar',
          child: SizedBox(
            width: 400,
            height: kToolbarHeight,
            child: MaterialApp(
              home: Scaffold(
                appBar: CustomAppBar(
                  title: 'Test Title',
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
                body: Container(),
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'CustomAppBar with custom color',
          child: SizedBox(
            width: 400,
            height: kToolbarHeight,
            child: MaterialApp(
              home: Scaffold(
                appBar: CustomAppBar(
                  title: 'Colored Title',
                  bgColor: Colors.red,
                ),
                body: Container(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
