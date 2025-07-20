import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'dart:developer';

class HapticService {
  static const String _hapticEnabledKey = 'haptic_enabled';

  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;

  Future<void> initialize() async {
    await _loadSettings();

    // Проверяем доступность вибрации при инициализации
    final hasVibrator = await Vibration.hasVibrator();

    log('🔊 HapticService initialized:', name: 'HapticService');
    log('  - hasVibrator: $hasVibrator', name: 'HapticService');
    log('  - isEnabled: $_isEnabled', name: 'HapticService');
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool(_hapticEnabledKey) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    if (_isEnabled != enabled) {
      _isEnabled = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hapticEnabledKey, enabled);
    }
  }

  Future<void> lightImpact() async {
    try {
      if (_isEnabled) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          HapticFeedback.lightImpact();
          log('🔊 Light impact triggered', name: 'HapticService');
        } else {
          log(
            '❌ No vibrator available for light impact',
            name: 'HapticService',
          );
        }
      } else {
        log('❌ Haptics disabled for light impact', name: 'HapticService');
      }
    } catch (e) {
      log('❌ Error in lightImpact: $e', name: 'HapticService');
    }
  }

  Future<void> mediumImpact() async {
    try {
      if (_isEnabled) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          HapticFeedback.mediumImpact();
          log('🔊 Medium impact triggered', name: 'HapticService');
        } else {
          log(
            '❌ No vibrator available for medium impact',
            name: 'HapticService',
          );
        }
      } else {
        log('❌ Haptics disabled for medium impact', name: 'HapticService');
      }
    } catch (e) {
      log('❌ Error in mediumImpact: $e', name: 'HapticService');
    }
  }

  Future<void> heavyImpact() async {
    try {
      if (_isEnabled) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          HapticFeedback.heavyImpact();
          log('🔊 Heavy impact triggered', name: 'HapticService');
        } else {
          log(
            '❌ No vibrator available for heavy impact',
            name: 'HapticService',
          );
        }
      } else {
        log('❌ Haptics disabled for heavy impact', name: 'HapticService');
      }
    } catch (e) {
      log('❌ Error in heavyImpact: $e', name: 'HapticService');
    }
  }

  Future<void> selectionClick() async {
    try {
      if (_isEnabled) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          HapticFeedback.selectionClick();
          log('🔊 Selection click triggered', name: 'HapticService');
        } else {
          log(
            '❌ No vibrator available for selection click',
            name: 'HapticService',
          );
        }
      } else {
        log('❌ Haptics disabled for selection click', name: 'HapticService');
      }
    } catch (e) {
      log('❌ Error in selectionClick: $e', name: 'HapticService');
    }
  }

  Future<void> vibrate() async {
    try {
      if (_isEnabled) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          Vibration.vibrate(duration: 50);
          log('🔊 Vibration triggered', name: 'HapticService');
        } else {
          log('❌ No vibrator available for vibration', name: 'HapticService');
        }
      } else {
        log('❌ Haptics disabled for vibration', name: 'HapticService');
      }
    } catch (e) {
      log('❌ Error in vibrate: $e', name: 'HapticService');
    }
  }
}
