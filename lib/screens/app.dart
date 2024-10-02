import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/routes/app_routes.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<String?> _determineInitialRoute(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final user = ref.watch(userProvider);

    if (user != null) {
      return '/home';
    }

    bool hasSeenSplash = prefs.getBool('has_seen_splash') ?? false;
    if (hasSeenSplash) {
      return '/login';
    }

    return '/';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String?>(
      future: _determineInitialRoute(ref),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return MaterialApp.router(
          title: 'AfrikFlow',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          routerConfig: GoRouter(
            initialLocation: snapshot.data!,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
