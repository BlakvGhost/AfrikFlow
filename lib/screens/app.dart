import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/base_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AfrikFlow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const BaseScreen(child: Text("Welcome")),
      debugShowCheckedModeBanner: false,
    );
  }
}
