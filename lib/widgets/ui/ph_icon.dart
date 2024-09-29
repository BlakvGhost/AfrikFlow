import 'package:afrik_flow/providers/theme_notifier.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhIcon extends ConsumerWidget {
  const PhIcon({
    super.key,
    required this.child,
    this.isWhite = false,
    this.smartColor = false,
    this.canMode = false,
  });

  final IconData child;
  final bool isWhite;
  final bool smartColor;
  final bool canMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final darkMode = themeMode == ThemeMode.dark;

    Color iconColor;
    if (isWhite) {
      iconColor = !darkMode
          ? (!smartColor ? AppTheme.primaryColor : AppTheme.backgroundColor)
          : AppTheme.primaryColor;
    } else {
      iconColor = AppTheme.primaryColor;
    }

    if (canMode) {
      iconColor = Colors.white;
    }

    return Icon(
      child,
      color: iconColor,
      size: 26.0,
    );
  }
}
