import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance/data/services/theme_service.dart';
import 'package:shmr_finance/data/services/haptic_service.dart';
import 'package:shmr_finance/data/services/security_service.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/presentation/pin_code_screen.dart';
import 'dart:developer';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
        centerTitle: true,
        toolbarHeight: 116,
      ),
      body: Consumer2<ThemeService, SecurityService>(
        builder: (context, themeService, securityService, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text("Системная тема"),
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
                title: const Text("Основной цвет"),
                trailing: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Выберите цвет'),
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
                              child: const Text('Отмена'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Сбросить'),
                              onPressed: () {
                                themeService.setPrimaryColor(
                                  const Color(0xff2ae881),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
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
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Выберите цвет'),
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
                            child: const Text('Отмена'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Сбросить'),
                            onPressed: () {
                              themeService.setPrimaryColor(
                                const Color(0xff2ae881),
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
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
                    title: const Text("Хаптик фидбек"),
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
                title: const Text("PIN-код"),
                subtitle: Text(
                  securityService.isPinCodeEnabled 
                      ? "Включен" 
                      : "Отключен"
                ),
                trailing: Switch(
                  value: securityService.isPinCodeEnabled,
                                  onChanged: (value) async {
                  if (value) {
                    // Включаем PIN-код - показываем экран установки
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PinCodeScreen(
                          isSetup: true,
                        ),
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
                        builder: (context) => const PinCodeScreen(
                          isSetup: true,
                        ),
                      ),
                    );
                    if (result == true) {
                      // PIN-код обновлен, состояние обновится автоматически через Consumer
                      log('🔐 PIN code updated successfully', name: 'SettingsPage');
                    }
                  } else {
                    // Включаем PIN-код
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PinCodeScreen(
                          isSetup: true,
                        ),
                      ),
                    );
                    if (result == true) {
                      // PIN-код установлен, включаем его
                      await securityService.setPinCodeEnabled(true);
                    }
                  }
                },
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
                    
                    String subtitle;
                    bool canToggle = false;
                    
                    if (!isConfigured) {
                      subtitle = "Не настроена в системе";
                    } else if (isEnabled) {
                      subtitle = "Включен";
                      canToggle = true;
                    } else {
                      subtitle = "Отключен";
                      canToggle = true;
                    }
                    
                    return ListTile(
                      title: const Text("Face ID / Touch ID"),
                      subtitle: Text(subtitle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isConfigured)
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Настройка биометрии'),
                                    content: const Text(
                                      'Для использования Face ID/Touch ID необходимо:\n\n'
                                      '1. Открыть Настройки → Face ID и пароль\n'
                                      '2. Настроить Face ID или Touch ID\n'
                                      '3. Вернуться в приложение\n\n'
                                      'После настройки биометрия станет доступной.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Понятно'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          if (canToggle)
                            Switch(
                              value: isEnabled,
                              onChanged: (value) async {
                                if (value && !securityService.isPinCodeEnabled) {
                                  // Нужно сначала включить PIN-код
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Сначала включите PIN-код'),
                                    ),
                                  );
                                  return;
                                }
                                await securityService.setBiometricEnabled(value);
                              },
                            ),
                        ],
                      ),
                      onTap: () async {
                        HapticService().lightImpact();
                        if (!isConfigured) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Настройте Face ID/Touch ID в системных настройках'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }
                        if (!securityService.isPinCodeEnabled) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Сначала включите PIN-код'),
                            ),
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
              if (securityService.isPinCodeEnabled) ...[
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: CustomAppTheme.figmaBgGrayColor,
                ),
                ListTile(
                  title: const Text("Тест PIN-кода"),
                  subtitle: const Text("Проверить ввод PIN-кода"),
                  onTap: () async {
                    HapticService().lightImpact();
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PinCodeScreen(
                          isSetup: false,
                        ),
                      ),
                    );
                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PIN-код введен правильно!'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
