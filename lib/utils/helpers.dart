import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const PhIcon(
            child: PhosphorIconsDuotone.info,
            isWhite: true,
            smartColor: true,
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(color: AppTheme.whiteColor),
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 114, 29, 22),
    ),
  );
}

bool isValidEmail(String email) {
  String pattern = r'^[^@]+@[^@]+\.[^@]+';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}
