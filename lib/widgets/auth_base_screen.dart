import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthBaseScreen extends ConsumerWidget {
  final Widget child;
  final bool isFullScreen;

  const AuthBaseScreen({
    super.key,
    required this.child,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
      return Scaffold(body: child);
    }

    return Scaffold(body: SafeArea(child: child));
  }
}
