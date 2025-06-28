import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';
part 'currency.g.dart';

@freezed
abstract class Currency with _$Currency {
  const factory Currency({
    required String code,
    required String name,
    required String symbol,
    required String icon,
  }) = _Currency;

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);
}

// Предопределенные валюты
class Currencies {
  static const List<Currency> available = [
    Currency(
      code: 'RUB',
      name: 'Российский рубль',
      symbol: '₽',
      icon: '🇷🇺',
    ),
    Currency(
      code: 'USD',
      name: 'Доллар США',
      symbol: '\$',
      icon: '🇺🇸',
    ),
    Currency(
      code: 'EUR',
      name: 'Евро',
      symbol: '€',
      icon: '🇪🇺',
    ),
    Currency(
      code: 'CNY',
      name: 'Китайский юань',
      symbol: '¥',
      icon: '🇨🇳',
    ),
    Currency(
      code: 'GBP',
      name: 'Фунт стерлингов',
      symbol: '£',
      icon: '🇬🇧',
    ),
  ];

  static Currency? getByCode(String code) {
    try {
      return available.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }
} 