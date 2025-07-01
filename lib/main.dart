import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance/data/services/balance_visibility_service.dart';
import 'package:shmr_finance/domain/cubit/account_cubit.dart';
import 'package:shmr_finance/domain/cubit/blur_cubit.dart';
import 'package:shmr_finance/domain/cubit/category_cubit.dart';
import 'package:shmr_finance/domain/cubit/transaction_cubit.dart';
import 'package:shmr_finance/presentation/account_page.dart';
import 'package:shmr_finance/presentation/categories_page.dart';
import 'package:shmr_finance/presentation/in_exp_widget.dart';
import 'package:shmr_finance/presentation/settings_page.dart';
import 'package:shmr_finance/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Небольшая задержка для стабильности инициализации
  await Future.delayed(const Duration(milliseconds: 100));
  
  try {
    await SharedPreferences.getInstance(); // Инициализируем SharedPreferences
    print('✅ SharedPreferences успешно инициализирован');
  } catch (e) {
    print('❌ Ошибка инициализации SharedPreferences: $e');
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
