import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  static const String _defaultLocale = 'ru';

  static final LocaleService _instance = LocaleService._internal();
  factory LocaleService() => _instance;
  LocaleService._internal();

  Locale _currentLocale = const Locale('ru');
  bool _isInitialized = false;

  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;

  // Поддерживаемые локали
  static const List<Locale> supportedLocales = [
    Locale('ru', ''), // Русский
    Locale('en', ''), // Английский
  ];

  // Инициализация сервиса
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey) ?? _defaultLocale;

      _currentLocale = Locale(savedLocale);
      _isInitialized = true;

      log('🌍 LocaleService инициализирован', name: 'Locale');
      log('  - Текущая локаль: ${_currentLocale.languageCode}', name: 'Locale');
      log(
        '  - Поддерживаемые локали: ${supportedLocales.map((l) => l.languageCode).join(', ')}',
        name: 'Locale',
      );
    } catch (e) {
      log('❌ Ошибка инициализации LocaleService: $e', name: 'Locale');
      // Используем локаль по умолчанию
      _currentLocale = const Locale(_defaultLocale);
      _isInitialized = true;
    }
  }

  // Изменение локали
  Future<void> setLocale(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale)) {
      log(
        '⚠️ Неподдерживаемая локаль: ${newLocale.languageCode}',
        name: 'Locale',
      );
      return;
    }

    if (_currentLocale == newLocale) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.languageCode);

      _currentLocale = newLocale;
      notifyListeners();

      log('🌍 Локаль изменена на: ${newLocale.languageCode}', name: 'Locale');
    } catch (e) {
      log('❌ Ошибка сохранения локали: $e', name: 'Locale');
    }
  }

  // Изменение локали по коду языка
  Future<void> setLocaleByCode(String languageCode) async {
    final newLocale = Locale(languageCode);
    await setLocale(newLocale);
  }

  // Получение названия локали
  String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  // Получение названия текущей локали
  String get currentLocaleName => getLocaleName(_currentLocale);

  // Проверка, является ли локаль русской
  bool get isRussian => _currentLocale.languageCode == 'ru';

  // Проверка, является ли локаль английской
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // Переключение между русским и английским
  Future<void> toggleLocale() async {
    if (isRussian) {
      await setLocaleByCode('en');
    } else {
      await setLocaleByCode('ru');
    }
  }

  // Получение списка доступных локалей с названиями
  List<MapEntry<Locale, String>> get availableLocales {
    return supportedLocales
        .map((locale) => MapEntry(locale, getLocaleName(locale)))
        .toList();
  }

  // Сброс к локали по умолчанию
  Future<void> resetToDefault() async {
    await setLocaleByCode(_defaultLocale);
  }

  // Получение информации о текущем состоянии
  Map<String, dynamic> getCurrentState() {
    return {
      'currentLocale': _currentLocale.languageCode,
      'currentLocaleName': currentLocaleName,
      'isRussian': isRussian,
      'isEnglish': isEnglish,
      'isInitialized': _isInitialized,
      'supportedLocales': supportedLocales.map((l) => l.languageCode).toList(),
    };
  }

  // Очистка ресурсов
  @override
  void dispose() {
    super.dispose();
    _isInitialized = false;
    log('🌍 LocaleService очищен', name: 'Locale');
  }
}
