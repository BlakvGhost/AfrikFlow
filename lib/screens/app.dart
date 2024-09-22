import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:afrik_flow/providers/theme_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'AfrikFlow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const BaseScreen(
          child: Center(
        child: Text("Welcome to AfrikFlow"),
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}
