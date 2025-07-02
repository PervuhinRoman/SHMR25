import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';
import 'package:shmr_finance/domain/cubit/account/blur_cubit.dart';
import 'package:shmr_finance/domain/cubit/categories/category_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/presentation/account_page.dart';
import 'package:shmr_finance/presentation/categories_page.dart';
import 'package:shmr_finance/presentation/in_exp_widget.dart';
import 'package:shmr_finance/presentation/settings_page.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:flutter/services.dart';

void main() async {
  // Устанавливаем цвета для статус бара и навигационной панели
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: CustomAppTheme.figmaNavBarColor,
      statusBarColor: CustomAppTheme.figmaMainColor,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  // Задержка для стабильности инициализации
  await Future.delayed(const Duration(milliseconds: 100));

  try {
    await SharedPreferences.getInstance(); // Инициализируем SharedPreferences
    log(
      '✅ SharedPreferences успешно инициализирован',
      time: DateTime.now(),
      name: 'SharedPrefs',
    );
  } catch (e) {
    log(
      '❌ Ошибка инициализации SharedPreferences: $e',
      time: DateTime.now(),
      name: 'SharedPrefs',
    );
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TransactionCubit()),
        BlocProvider(create: (_) => MyAccountCubit()),
        BlocProvider(create: (_) => BlurCubit()),
        BlocProvider(create: (_) => CategoryCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 16)),
          colorScheme: ColorScheme.light(
            primary: CustomAppTheme.figmaMainColor,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: CustomAppTheme.figmaMainColor,
          ),
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: CustomAppTheme.figmaMainLightColor,
            backgroundColor: CustomAppTheme.figmaNavBarColor,
          ),
        ),
        home: const BaseScreen(),
      ),
    );
  }
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        // TODO: ?заменить на svg
        destinations: <Widget>[
          NavigationDestination(
            icon: Image.asset('assets/icons/downtrend.png', width: 32),
            label: 'Расходы',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/uptrend.png', width: 32),
            label: 'Доходы',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/calc.png', width: 32),
            label: 'Счет',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/linear_chart.png', width: 32),
            label: 'Статьи',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/settings.png', width: 32),
            label: 'Настройки',
          ),
        ],
      ),
      body:
          [
            InExpWidget(isIncome: false),
            InExpWidget(isIncome: true),
            AccountPage(),
            CategoriesPage(),
            SettingsPage(),
          ][currentPageIndex],
    );
  }
}
