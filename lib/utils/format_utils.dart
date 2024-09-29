class FormatUtils {
  static String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} FCFA';
  }
}

String formatDuration(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$remainingSeconds';
}
