import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;

  const AppLogo({
    super.key,
    this.size = 100.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(
        'assets/logos/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
