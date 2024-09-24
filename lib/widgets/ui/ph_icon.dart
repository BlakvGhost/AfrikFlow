import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';

class PhIcon extends StatelessWidget {
  const PhIcon({super.key, required this.child});

  final IconData child;

  @override
  Widget build(BuildContext context) {
    return Icon(
      child,
      color: AppTheme.primaryColor,
      size: 30.0,
    );
  }
}
