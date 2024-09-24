import 'package:afrik_flow/widgets/ui/custom_drawer.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/providers/theme_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
                icon: !isDarkMode
                    ? const PhIcon(
                        child: PhosphorIconsDuotone.sun, isWhite: true)
                    : const PhIcon(
                        child: PhosphorIconsDuotone.moon, isWhite: true),
                onPressed: () {
                  ref.read(themeNotifierProvider.notifier).toggleTheme();
                },
              ),
            ],
            leading: Builder(
              builder: (context) => IconButton(
                icon: const PhIcon(
                    child: PhosphorIconsDuotone.list, isWhite: true),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
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
              context.push('/send');
              break;
            case 2:
              context.push('/transactions');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: PhIcon(child: PhosphorIconsDuotone.house),
              label: 'Accueil'),
          BottomNavigationBarItem(
              icon: PhIcon(child: PhosphorIconsDuotone.paperPlaneTilt),
              label: 'Envoyer'),
          BottomNavigationBarItem(
              icon: PhIcon(child: PhosphorIconsDuotone.cardholder),
              label: 'Transactions'),
          BottomNavigationBarItem(
              icon: PhIcon(child: PhosphorIconsDuotone.userCircleGear),
              label: 'Profil'),
        ],
      ),
    );
  }
}
