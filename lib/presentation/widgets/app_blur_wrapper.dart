import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shmr_finance/presentation/services/app_blur_service.dart';

class AppBlurWrapper extends StatefulWidget {
  final Widget child;
  final double blurIntensity;
  
  const AppBlurWrapper({
    super.key,
    required this.child,
    this.blurIntensity = 15.0,
  });

  @override
  State<AppBlurWrapper> createState() => _AppBlurWrapperState();
}

class _AppBlurWrapperState extends State<AppBlurWrapper> with WidgetsBindingObserver {
  final AppBlurService _blurService = AppBlurService();
  bool _shouldShowBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeBlurService();
  }

  Future<void> _initializeBlurService() async {
    await _blurService.initialize();
    _blurService.setBlurStateCallback(_onBlurStateChanged);
    
    // Проверяем текущее состояние
    final state = _blurService.getCurrentState();
    setState(() {
      _shouldShowBlur = state['shouldShowBlur'] ?? false;
    });
  }

  void _onBlurStateChanged() {
    final state = _blurService.getCurrentState();
    setState(() {
      _shouldShowBlur = state['shouldShowBlur'] ?? false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _blurService.handleAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowBlur) {
      return widget.child;
    }

    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        // Основной контент
        widget.child,
        // Слой блюра поверх всего приложения
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blurIntensity,
                sigmaY: widget.blurIntensity,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 60,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Приложение заблокировано',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Сверните приложение для разблокировки',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _blurService.dispose();
    super.dispose();
  }
} 