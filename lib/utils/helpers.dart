import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void showToast(BuildContext context, dynamic message, {isList = false}) {
  if (isList) {
    message = formatErrorMessage(message);
  }

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
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppTheme.whiteColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 8,
            ),
          ),
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

String formatErrorMessage(Map<String, dynamic> errors) {
  StringBuffer formattedMessage = StringBuffer();

  errors.forEach((key, value) {
    if (value is List<String>) {
      formattedMessage.writeln(value.join(', '));
    } else if (value is List<dynamic>) {
      formattedMessage.writeln(value.map((v) => v.toString()).join(', '));
    } else {
      formattedMessage.writeln(value);
    }
  });

  return formattedMessage.toString();
}
