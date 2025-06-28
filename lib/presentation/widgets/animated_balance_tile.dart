import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/blur_cubit.dart';

import '../../domain/cubit/blur_state.dart';

class AnimatedBalanceTile extends StatefulWidget {
  final String icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const AnimatedBalanceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  State<AnimatedBalanceTile> createState() => _AnimatedBalanceTileState();
}

class _AnimatedBalanceTileState extends State<AnimatedBalanceTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final blurCubit = context.read<BlurCubit>();

    // Устанавливаем начальное состояние
    if (!blurCubit.state.isBalanceVisible) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlurCubit, BlurState>(
      builder: (context, state) {
        // Обновляем анимацию при изменении состояния
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.isBalanceVisible) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        });

        return Material(
          color: CustomAppTheme.figmaMainLightColor,
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Text(widget.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(widget.title)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: _blurAnimation.value,
                            sigmaY: _blurAnimation.value,
                          ),
                          child: Text(widget.value),
                        );
                      },
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
