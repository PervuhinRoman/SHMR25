import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance/data/services/theme_service.dart';
import 'package:shmr_finance/data/services/haptic_service.dart';
import 'package:shmr_finance/data/services/security_service.dart';
import 'package:shmr_finance/data/services/locale_service.dart';
import 'package:shmr_finance/presentation/services/app_blur_service.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/presentation/pin_code_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:developer';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showLanguageDialog(BuildContext context, LocaleService localeService) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                localeService.availableLocales.map((entry) {
                  final locale = entry.key;
                  final name = entry.value;
                  final isSelected =
                      locale.languageCode ==
                      localeService.currentLocale.languageCode;

                  return ListTile(
                    title: Text(name),
                    trailing:
                        isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                    onTap: () async {
                      await localeService.setLocale(locale);
                      Navigator.of(dialogContext).pop();
                    },
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        toolbarHeight: 116,
      ),
      body: Consumer3<ThemeService, SecurityService, LocaleService>(
        builder: (
          context,
          themeService,
          securityService,
          localeService,
          child,
        ) {
          return ListView(
            children: [
              ListTile(
                title: Text(l10n.systemTheme),
                trailing: Switch(
                  value: themeService.useSystemTheme,
                  onChanged: (value) {
                    themeService.setUseSystemTheme(value);
                  },
                ),
                onTap: () {
                  HapticService().lightImpact();
                  themeService.setUseSystemTheme(!themeService.useSystemTheme);
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              ListTile(
                title: Text(l10n.primaryColor),
                trailing: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(l10n.primaryColor),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: themeService.primaryColor,
                              onColorChanged: (Color color) {
                                themeService.setPrimaryColor(color);
                              },
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(l10n.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(l10n.reset),
                              onPressed: () {
                                themeService.setPrimaryColor(
                                  const Color(0xff2ae881),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(l10n.ok),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: themeService.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  HapticService().lightImpact();
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      final dialogL10n = AppLocalizations.of(dialogContext)!;
                      return AlertDialog(
                        title: Text(dialogL10n.primaryColor),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: themeService.primaryColor,
                            onColorChanged: (Color color) {
                              themeService.setPrimaryColor(color);
                            },
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(dialogL10n.cancel),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                          TextButton(
                            child: Text(dialogL10n.reset),
                            onPressed: () {
                              themeService.setPrimaryColor(
                                const Color(0xff2ae881),
                              );
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                          TextButton(
                            child: Text(dialogL10n.ok),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return ListTile(
                    title: Text(l10n.hapticFeedback),
                    trailing: Switch(
                      value: HapticService().isEnabled,
                      onChanged: (value) async {
                        await HapticService().setEnabled(value);
                        setState(() {});
                      },
                    ),
                    onTap: () async {
                      HapticService().lightImpact();
                      await HapticService().setEnabled(
                        !HapticService().isEnabled,
                      );
                      setState(() {});
                    },
                  );
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              ListTile(
                title: Text(l10n.pinCode),
                trailing: Switch(
                  value: securityService.isPinCodeEnabled,
                  onChanged: (value) async {
                    if (value) {
                      // Включаем PIN-код - показываем экран установки
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const PinCodeScreen(isSetup: true),
                        ),
                      );
                      if (result == true) {
                        // PIN-код установлен, включаем его
                        await securityService.setPinCodeEnabled(true);
                      }
                    } else {
                      // Отключаем PIN-код
                      await securityService.setPinCodeEnabled(false);
                    }
                  },
                ),
                onTap: () async {
                  HapticService().lightImpact();
                  if (securityService.isPinCodeEnabled) {
                    // Редактируем PIN-код
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const PinCodeScreen(isSetup: true),
                      ),
                    );
                    if (result == true) {
                      // PIN-код обновлен, состояние обновится автоматически через Consumer
                      log(
                        '🔐 PIN code updated successfully',
                        name: 'SettingsPage',
                      );
                    }
                  } else {
                    // Включаем PIN-код
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const PinCodeScreen(isSetup: true),
                      ),
                    );
                    if (result == true) {
                      // PIN-код установлен, включаем его
                      await securityService.setPinCodeEnabled(true);
                    }
                  }
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: securityService.getBiometricInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final info = snapshot.data!;
                    final isDeviceSupported = info['isDeviceSupported'] as bool;
                    final isConfigured = info['isConfigured'] as bool;
                    final isEnabled = info['isEnabled'] as bool;

                    if (!isDeviceSupported) {
                      return const SizedBox.shrink(); // Устройство не поддерживает биометрию
                    }

                    bool canToggle = false;

                    if (!isConfigured) {
                    } else if (isEnabled) {
                      canToggle = true;
                    } else {
                      canToggle = true;
                    }

                    return ListTile(
                      title: Text(l10n.biometrics),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isConfigured)
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    final dialogL10n =
                                        AppLocalizations.of(dialogContext)!;
                                    return AlertDialog(
                                      title: Text(
                                        dialogL10n.biometricSetupRequired,
                                      ),
                                      content: Text(
                                        'Для использования Face ID/Touch ID необходимо:\n\n'
                                        '1. Открыть Настройки → Face ID и пароль\n'
                                        '2. Настроить Face ID или Touch ID\n'
                                        '3. Вернуться в приложение\n\n'
                                        'После настройки биометрия станет доступной.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(dialogContext),
                                          child: Text(dialogL10n.ok),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          if (canToggle)
                            Switch(
                              value: isEnabled,
                              onChanged: (value) async {
                                if (value &&
                                    !securityService.isPinCodeEnabled) {
                                  // Нужно сначала включить PIN-код
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.pinCodeRequired),
                                    ),
                                  );
                                  return;
                                }
                                await securityService.setBiometricEnabled(
                                  value,
                                );
                              },
                            ),
                        ],
                      ),
                      onTap: () async {
                        HapticService().lightImpact();
                        if (!isConfigured) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.biometricSetupRequired),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          return;
                        }
                        if (!securityService.isPinCodeEnabled) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.pinCodeRequired)),
                          );
                          return;
                        }
                        final newValue = !isEnabled;
                        await securityService.setBiometricEnabled(newValue);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              if (securityService.isPinCodeEnabled)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: CustomAppTheme.figmaBgGrayColor,
                ),
              StatefulBuilder(
                builder: (context, setState) {
                  return ListTile(
                    title: Text(l10n.appBlur),
                    subtitle: Text(l10n.appBlurDescription),
                    trailing: Switch(
                      value: AppBlurService().isBlurEnabled,
                      onChanged: (value) async {
                        await AppBlurService().setBlurEnabled(value);
                        setState(() {});
                      },
                    ),
                    onTap: () async {
                      HapticService().lightImpact();
                      final newValue = !AppBlurService().isBlurEnabled;
                      await AppBlurService().setBlurEnabled(newValue);
                      setState(() {});
                    },
                  );
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              ListTile(
                title: Text(l10n.language),
                subtitle: Text(localeService.currentLocaleName),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  HapticService().lightImpact();
                  _showLanguageDialog(context, localeService);
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
