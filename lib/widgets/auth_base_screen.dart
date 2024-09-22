import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthBaseScreen extends ConsumerWidget {
  final Widget child;

  const AuthBaseScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: child);
  }
}
