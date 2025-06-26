import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/presentation/account_page.dart';
import 'package:shmr_finance/presentation/categories_page.dart';
import 'package:shmr_finance/presentation/expenses_page.dart';
import 'package:shmr_finance/presentation/in_exp_widget_page.dart';
import 'package:shmr_finance/presentation/income_page.dart';
import 'package:shmr_finance/presentation/settings_page.dart';
import 'package:shmr_finance/app_theme.dart';

import 'domain/bloc/transaction_bloc.dart';
import 'domain/cubit/datepicker_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 16)),
        colorScheme: ColorScheme.light(primary: CustomAppTheme.figmaMainColor),
        appBarTheme: AppBarTheme(
          backgroundColor: CustomAppTheme.figmaMainColor,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: CustomAppTheme.figmaMainLightColor,
          backgroundColor: CustomAppTheme.figmaNavBarColor,
        ),
      ),
      home: const BaseScreen(),
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
      body: [
        // BlocProvider(
        //   create: (context) {
        //     final now = DateTime.now();
        //     final startDate = DateTime(now.year, now.month - 1, now.day);
        //     return TransactionBloc()..add(LoadTransactions(false, startDate, now));
        //   },
        //   child: InExpWidgetPage(isIncome: false),
        // ),
        BlocProvider(
          create: (context) => DatePickerCubit(),
          child: InExpWidgetPage(isIncome: false),
        ),
        // BlocProvider(
        //   create: (context) {
        //     final now = DateTime.now();
        //     final startDate = DateTime(now.year, now.month - 1, now.day);
        //     return TransactionBloc()..add(LoadTransactions(true, startDate, now));
        //   },
        //   child: InExpWidgetPage(isIncome: true),
        // ),
        BlocProvider(
          create: (context) => DatePickerCubit(),
          child: InExpWidgetPage(isIncome: true),
        ),
        AccountPage(),
        CategoriesPage(),
        SettingsPage(),
      ][currentPageIndex],
    );
  }
}
