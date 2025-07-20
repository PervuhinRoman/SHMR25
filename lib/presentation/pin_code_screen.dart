import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shmr_finance/presentation/services/security_service.dart';
import 'package:shmr_finance/presentation/services/haptic_service.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinCodeScreen extends StatefulWidget {
  final bool isSetup; // true - установка PIN, false - ввод PIN
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  final VoidCallback?
  onBackToAuthOptions; // для возврата к выбору способа аутентификации

  const PinCodeScreen({
    super.key,
    required this.isSetup,
    this.onSuccess,
    this.onCancel,
    this.onBackToAuthOptions,
  });

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final List<String> _pinCode = [];
  final List<String> _confirmPinCode = [];
  bool _isConfirming = false;
  bool _isError = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          widget.isSetup
              ? AppBar(
                title: Text(l10n.pinCodeSetup),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    HapticService().lightImpact();
                    widget.onCancel?.call();
                    Navigator.of(context).pop();
                  },
                ),
              )
              : AppBar(
                title: Text(l10n.enterPinCode),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    HapticService().lightImpact();
                    widget.onBackToAuthOptions?.call();
                    Navigator.of(context).pop();
                  },
                ),
              ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildTitle(),
            const SizedBox(height: 40),
            _buildPinDots(),
            const SizedBox(height: 40),
            _buildErrorMessage(),
            const Spacer(),
            _buildNumericKeypad(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final l10n = AppLocalizations.of(context)!;
    String title;
    if (widget.isSetup) {
      title = _isConfirming ? l10n.confirmPinCode : l10n.setupPinCode;
    } else {
      title = l10n.enterPinCode;
    }

    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPinDots() {
    final currentPin = _isConfirming ? _confirmPinCode : _pinCode;
    final maxLength = 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final isFilled = index < currentPin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _isError
                    ? Colors.red
                    : isFilled
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  Widget _buildErrorMessage() {
    if (!_isError) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        _errorMessage,
        style: const TextStyle(color: Colors.red, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Column(
      children: [
        for (int row = 0; row < 3; row++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int col = 0; col < 3; col++)
                _buildKeypadButton(
                  text: '${row * 3 + col + 1}',
                  onPressed: () => _addDigit('${row * 3 + col + 1}'),
                ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton(text: '', onPressed: null),
            _buildKeypadButton(text: '0', onPressed: () => _addDigit('0')),
            _buildKeypadButton(text: '⌫', onPressed: _removeDigit),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 70,
      height: 70,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  onPressed != null
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.transparent,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: text == '⌫' ? 20 : 24,
                  fontWeight: FontWeight.w500,
                  color:
                      onPressed != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addDigit(String digit) {
    HapticService().lightImpact();

    if (_isError) {
      setState(() {
        _isError = false;
        _errorMessage = '';
      });
    }

    if (_isConfirming) {
      if (_confirmPinCode.length < 4) {
        setState(() {
          _confirmPinCode.add(digit);
        });

        if (_confirmPinCode.length == 4) {
          _verifyConfirmPin();
        }
      }
    } else {
      if (_pinCode.length < 4) {
        setState(() {
          _pinCode.add(digit);
        });

        if (_pinCode.length == 4) {
          if (widget.isSetup) {
            _startConfirmPin();
          } else {
            _verifyPin();
          }
        }
      }
    }
  }

  void _removeDigit() {
    HapticService().lightImpact();

    if (_isError) {
      setState(() {
        _isError = false;
        _errorMessage = '';
      });
    }

    if (_isConfirming) {
      if (_confirmPinCode.isNotEmpty) {
        setState(() {
          _confirmPinCode.removeLast();
        });
      }
    } else {
      if (_pinCode.isNotEmpty) {
        setState(() {
          _pinCode.removeLast();
        });
      }
    }
  }

  void _startConfirmPin() {
    setState(() {
      _isConfirming = true;
    });
  }

  Future<void> _verifyConfirmPin() async {
    final l10n = AppLocalizations.of(context)!;
    final pin = _pinCode.join();
    final confirmPin = _confirmPinCode.join();

    if (pin == confirmPin) {
      try {
        await SecurityService().setPinCode(pin);
        HapticService().mediumImpact();
        widget.onSuccess?.call();
        Navigator.of(
          context,
        ).pop(true); // Возвращаем true для успешной установки
      } catch (e) {
        setState(() {
          _isError = true;
          _errorMessage = l10n.pinCodeSaveError;
        });
      }
    } else {
      setState(() {
        _isError = true;
        _errorMessage = l10n.pinCodesDontMatch;
        _confirmPinCode.clear();
      });
      HapticService().heavyImpact();
    }
  }

  Future<void> _verifyPin() async {
    final l10n = AppLocalizations.of(context)!;
    final pin = _pinCode.join();
    final isValid = await SecurityService().verifyPinCode(pin);

    if (isValid) {
      HapticService().mediumImpact();
      widget.onSuccess?.call();
      Navigator.of(
        context,
      ).pop(true); // Возвращаем true для успешной аутентификации
    } else {
      setState(() {
        _isError = true;
        _errorMessage = l10n.incorrectPinCode;
        _pinCode.clear();
      });
      HapticService().heavyImpact();
    }
  }
}
