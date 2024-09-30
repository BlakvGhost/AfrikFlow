import 'package:flutter/material.dart';
import 'package:afrik_flow/themes/app_theme.dart';

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: AppTheme.whiteColor),
      ),
      backgroundColor: const Color.fromARGB(255, 114, 29, 22),
    ),
  );
}
