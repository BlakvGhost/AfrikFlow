import 'package:afrik_flow/widgets/ui/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/providers/theme_notifier.dart';
import 'package:go_router/go_router.dart';

class BaseScreen extends ConsumerWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;
  final Widget? floatingActionButton;
  final int? currentIndex;
  final Function(int)? onTabTapped;

  AppBar getHomePageAppBar(double width, BuildContext context, WidgetRef ref,
      bool showAppBar, String? title) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return showAppBar
        ? AppBar(
            title: Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: width * 0.4,
            ),
            centerTitle: true,
            elevation: 18,
            actions: [
              IconButton(
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  ref.read(themeNotifierProvider.notifier).toggleTheme();
                },
              ),
            ],
          )
        : AppBar(
            title: Text(title ?? 'AfrikFlow'),
            elevation: 18,
          );
  }

  const BaseScreen({
    super.key,
    required this.child,
    this.title,
    this.showAppBar = true,
    this.floatingActionButton,
    this.currentIndex = 0,
    this.onTabTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getHomePageAppBar(screenWidth, context, ref, showAppBar, title),
      body: child,
      floatingActionButton: floatingActionButton,
      drawer: const CustomDrawer(
        name: 'Kabirou ALASSANE',
        email: 'email@example.com',
        avatarUrl: 'https://avatars.githubusercontent.com/u/86885681?v=4',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex!,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/send');
              break;
            case 2:
              context.go('/transactions');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Envoyer'),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Transactions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
      ),
    );
  }
}
