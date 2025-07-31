import 'package:flutter/material.dart';
import 'package:shmr_finance/presentation/services/security_service.dart';
import 'package:shmr_finance/presentation/services/haptic_service.dart';
import 'package:shmr_finance/presentation/pin_code_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shmr_finance/l10n/app_localizations.dart';

class SecurityScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const SecurityScreen({super.key, required this.onAuthenticated});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _isAuthenticating = false;
  bool _showAuthOptions = false;

  @override
  void initState() {
    super.initState();
    _checkAuthOptions();
  }

  Future<void> _checkAuthOptions() async {
    final securityService = SecurityService();
    final authMethods = await securityService.getAvailableAuthMethods();
    final hasPinCode = authMethods['pinCode'] ?? false;
    final hasBiometric = authMethods['biometric'] ?? false;

    if (hasPinCode && hasBiometric) {
      // Если доступны оба способа, показываем выбор
      setState(() {
        _showAuthOptions = true;
      });
    } else if (hasBiometric) {
      // Если доступна только биометрия, пробуем её
      _authenticateWithBiometric();
    } else if (hasPinCode) {
      // Если доступен только PIN-код, показываем его
      _showPinCodeScreen();
    } else {
      // Если ничего не доступно, разблокируем
      widget.onAuthenticated();
    }
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Сначала проверяем доступность биометрии
      final isAvailable = await SecurityService().isBiometricAvailable();
      if (!isAvailable) {
        _showBiometricError();
        _showPinCodeScreen();
        return;
      }

      final isAuthenticated = await SecurityService()
          .authenticateWithBiometrics();

      if (isAuthenticated) {
        widget.onAuthenticated();
      } else {
        // Если биометрия не сработала, показываем PIN-код
        _showPinCodeScreen();
      }
    } catch (e) {
      // В случае ошибки показываем PIN-код
      _showBiometricError();
      _showPinCodeScreen();
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _showBiometricError() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.biometricUnavailable),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _showPinCodeScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinCodeScreen(
          isSetup: false,
          onBackToAuthOptions: () {
            setState(() {
              _showAuthOptions = true;
            });
          },
        ),
      ),
    );

    if (result == true) {
      widget.onAuthenticated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.appLocked,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.confirmIdentity,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            if (_isAuthenticating)
              const CircularProgressIndicator()
            else if (_showAuthOptions)
              _buildAuthOptions()
            else
              ElevatedButton(
                onPressed: _checkAuthOptions,
                child: Text(l10n.unlock),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthOptions() {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<bool>(
      future: SecurityService().isBiometricAvailable(),
      builder: (context, snapshot) {
        final isBiometricAvailable = snapshot.data ?? false;

        if (!isBiometricAvailable) {
          // Если биометрия недоступна, показываем только PIN-код
          return SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticService().lightImpact();
                _showPinCodeScreen();
              },
              icon: const Icon(Icons.pin),
              label: Text(l10n.pinCode),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          );
        }

        // Если биометрия доступна, показываем оба варианта
        return FutureBuilder<List<BiometricType>>(
          future: SecurityService().getAvailableBiometrics(),
          builder: (context, biometricSnapshot) {
            String biometricLabel = l10n.faceIdTouchId;
            IconData biometricIcon = Icons.fingerprint;

            if (biometricSnapshot.hasData) {
              final biometrics = biometricSnapshot.data!;
              if (biometrics.contains(BiometricType.face)) {
                biometricLabel = l10n.faceId;
                biometricIcon = Icons.face;
              } else if (biometrics.contains(BiometricType.fingerprint)) {
                biometricLabel = l10n.touchId;
                biometricIcon = Icons.fingerprint;
              }
            }

            return Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticService().lightImpact();
                      _authenticateWithBiometric();
                    },
                    icon: Icon(biometricIcon),
                    label: Text(biometricLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticService().lightImpact();
                      _showPinCodeScreen();
                    },
                    icon: const Icon(Icons.pin),
                    label: Text(l10n.pinCode),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
