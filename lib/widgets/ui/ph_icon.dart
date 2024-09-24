import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';

class PhIcon extends StatelessWidget {
  const PhIcon({super.key, required this.child, this.isWhite = false});

  final IconData child;

  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return Icon(
      child,
      color: isWhite ? AppTheme.backgroundColor : AppTheme.primaryColor,
      size: 30.0,
    );
  }
}
