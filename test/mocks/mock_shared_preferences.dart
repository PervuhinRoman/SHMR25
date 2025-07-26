import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  final Map<String, dynamic> _storage = {};

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  String? getString(String key) => _storage[key] as String?;
}
