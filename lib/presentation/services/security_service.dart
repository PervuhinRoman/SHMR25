import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:developer';

class SecurityService extends ChangeNotifier {
  static const String _pinCodeKey = 'pin_code';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _pinCodeEnabledKey = 'pin_code_enabled';

  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isPinCodeEnabled = false;
  bool _isBiometricEnabled = false;
  String? _pinCode;

  bool get isPinCodeEnabled => _isPinCodeEnabled;
  bool get isBiometricEnabled => _isBiometricEnabled;
  String? get pinCode => _pinCode;

  Future<void> initialize() async {
    await _loadSettings();

    log('🔐 SecurityService initialized:', name: 'SecurityService');
    log('  - isPinCodeEnabled: $_isPinCodeEnabled', name: 'SecurityService');
    log(
      '  - isBiometricEnabled: $_isBiometricEnabled',
      name: 'SecurityService',
    );
    log('  - hasPinCode: ${_pinCode != null}', name: 'SecurityService');
  }

  Future<void> _loadSettings() async {
    _isPinCodeEnabled =
        await _secureStorage.read(key: _pinCodeEnabledKey) == 'true';
    _isBiometricEnabled =
        await _secureStorage.read(key: _biometricEnabledKey) == 'true';
    _pinCode = await _secureStorage.read(key: _pinCodeKey);

    log('🔐 Loaded settings:', name: 'SecurityService');
    log(
      '  - PIN enabled from storage: $_isPinCodeEnabled',
      name: 'SecurityService',
    );
    log(
      '  - Biometric enabled from storage: $_isBiometricEnabled',
      name: 'SecurityService',
    );
    log(
      '  - PIN code from storage: ${_pinCode != null ? "***" : "null"}',
      name: 'SecurityService',
    );
  }

  Future<void> setPinCodeEnabled(bool enabled) async {
    log('🔐 Setting PIN code enabled: $enabled', name: 'SecurityService');
    if (_isPinCodeEnabled != enabled) {
      _isPinCodeEnabled = enabled;
      await _secureStorage.write(
        key: _pinCodeEnabledKey,
        value: enabled.toString(),
      );

      // Проверяем, что настройка сохранилась
      final savedEnabled = await _secureStorage.read(key: _pinCodeEnabledKey);
      log('🔐 Verified saved enabled: $savedEnabled', name: 'SecurityService');

      // Если отключаем PIN-код, то отключаем и биометрию
      if (!enabled && _isBiometricEnabled) {
        await setBiometricEnabled(false);
      }

      log('🔐 PIN code enabled: $enabled', name: 'SecurityService');
      notifyListeners();
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    if (_isBiometricEnabled != enabled) {
      _isBiometricEnabled = enabled;
      await _secureStorage.write(
        key: _biometricEnabledKey,
        value: enabled.toString(),
      );
      log('🔐 Biometric enabled: $enabled', name: 'SecurityService');
      notifyListeners();
    }
  }

  Future<void> setPinCode(String pin) async {
    log('🔐 Setting PIN code: $pin', name: 'SecurityService');
    if (pin.length == 4 && pin.contains(RegExp(r'^[0-9]+$'))) {
      _pinCode = pin;
      await _secureStorage.write(key: _pinCodeKey, value: pin);
      log('🔐 PIN code saved to secure storage', name: 'SecurityService');

      // Проверяем, что PIN-код сохранился
      final savedPin = await _secureStorage.read(key: _pinCodeKey);
      log(
        '🔐 Verified saved PIN: ${savedPin != null ? "***" : "null"}',
        name: 'SecurityService',
      );

      notifyListeners();
    } else {
      log('❌ Invalid PIN code format: $pin', name: 'SecurityService');
      throw Exception('PIN code must be 4 digits');
    }
  }

  Future<bool> verifyPinCode(String pin) async {
    if (_pinCode == null) return false;
    final isValid = _pinCode == pin;
    log('🔐 PIN verification: $isValid', name: 'SecurityService');
    return isValid;
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final hasBiometrics = await _localAuth.getAvailableBiometrics();

      final result =
          isAvailable && isDeviceSupported && hasBiometrics.isNotEmpty;
      log('🔐 Biometric availability check:', name: 'SecurityService');
      log('  - canCheckBiometrics: $isAvailable', name: 'SecurityService');
      log('  - isDeviceSupported: $isDeviceSupported', name: 'SecurityService');
      log(
        '  - availableBiometrics: ${hasBiometrics.length}',
        name: 'SecurityService',
      );
      log('  - result: $result', name: 'SecurityService');

      if (!result) {
        if (!isDeviceSupported) {
          log('  - Reason: Device not supported', name: 'SecurityService');
        } else if (hasBiometrics.isEmpty) {
          log('  - Reason: No biometrics configured', name: 'SecurityService');
        } else if (!isAvailable) {
          log('  - Reason: Cannot check biometrics', name: 'SecurityService');
        }
      }

      return result;
    } catch (e) {
      log(
        '❌ Error checking biometric availability: $e',
        name: 'SecurityService',
      );
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      log('❌ Error getting available biometrics: $e', name: 'SecurityService');
      return [];
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      // Проверяем доступность биометрии перед аутентификацией
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        log('❌ Biometric not available', name: 'SecurityService');
        return false;
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Подтвердите вашу личность для входа в приложение',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      log(
        '🔐 Biometric authentication: $isAuthenticated',
        name: 'SecurityService',
      );
      return isAuthenticated;
    } catch (e) {
      log('❌ Error in biometric authentication: $e', name: 'SecurityService');
      return false;
    }
  }

  Future<bool> shouldShowSecurityScreen() async {
    return _isPinCodeEnabled || _isBiometricEnabled;
  }

  Future<Map<String, bool>> getAvailableAuthMethods() async {
    final hasPinCode = _isPinCodeEnabled && _pinCode != null;
    final hasBiometric = _isBiometricEnabled && await isBiometricAvailable();

    return {'pinCode': hasPinCode, 'biometric': hasBiometric};
  }

  Future<Map<String, dynamic>> getBiometricInfo() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final hasBiometrics = await _localAuth.getAvailableBiometrics();

      return {
        'canCheckBiometrics': isAvailable,
        'isDeviceSupported': isDeviceSupported,
        'availableBiometrics': hasBiometrics,
        'isConfigured': hasBiometrics.isNotEmpty,
        'isEnabled': _isBiometricEnabled,
      };
    } catch (e) {
      log('❌ Error getting biometric info: $e', name: 'SecurityService');
      return {
        'canCheckBiometrics': false,
        'isDeviceSupported': false,
        'availableBiometrics': <BiometricType>[],
        'isConfigured': false,
        'isEnabled': false,
      };
    }
  }

  Future<bool> authenticate() async {
    if (!await shouldShowSecurityScreen()) {
      return true;
    }

    // Проверяем, есть ли доступные способы аутентификации
    final hasPinCode = _isPinCodeEnabled && _pinCode != null;
    final hasBiometric = _isBiometricEnabled && await isBiometricAvailable();

    // Если нет доступных способов, разрешаем доступ
    if (!hasPinCode && !hasBiometric) {
      return true;
    }

    // Возвращаем false, чтобы показать экран выбора способа аутентификации
    return false;
  }
}
