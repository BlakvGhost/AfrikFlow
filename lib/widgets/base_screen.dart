import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BaseScreen extends ConsumerWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;
  final Widget? floatingActionButton;
  final int? currentIndex;
  final Function(int)? onTabTapped;

  Future<AppBar?> getHomePageAppBar(double width, BuildContext context,
      WidgetRef ref, bool showAppBar, String? title) async {
    final user = ref.watch(userProvider);

    return AppBar(
      automaticallyImplyLeading: showAppBar,
      title: showAppBar
          ? Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: width * 0.4,
            )
          : Text(title ?? 'AfrikFlow'),
      elevation: 18,
      actions: [
        IconButton(
          icon: const PhIcon(
            child: PhosphorIconsDuotone.bell,
            isWhite: true,
            smartColor: true,
          ),
          onPressed: () {
            context.push('/notifications');
          },
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(user?.avatar ??
                "https://avatars.githubusercontent.com/u/86885681?v=4"),
          ),
          onPressed: () {
            context.push('/profile');
            // ref.read(themeNotifierProvider.notifier).toggleTheme();
          },
        ),
      ],
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return FutureBuilder<AppBar?>(
      future: getHomePageAppBar(screenWidth, context, ref, showAppBar, title),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: snapshot.data,
          body: child,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButtonAnimator:
              FloatingActionButtonAnimator.noAnimation,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.push('/send');
            },
            backgroundColor: AppTheme.primaryColor,
            child: const PhIcon(
              child: PhosphorIconsDuotone.paperPlaneTilt,
              canMode: true,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 28,
            currentIndex: currentIndex!,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.push('/transactions');
                  break;
                case 2:
                  context.push('/send');
                  break;
                case 3:
                  context.push('/profile');
                  break;
                case 4:
                  context.push('/settings');
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: PhIcon(child: PhosphorIconsDuotone.house),
                  label: 'Accueil'),
              BottomNavigationBarItem(
                  icon: PhIcon(child: PhosphorIconsDuotone.cardholder),
                  label: 'Transactions'),
              BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
              BottomNavigationBarItem(
                  icon: PhIcon(child: PhosphorIconsDuotone.userCircleGear),
                  label: 'Profil'),
              BottomNavigationBarItem(
                  icon: PhIcon(child: PhosphorIconsDuotone.gearSix),
                  label: 'Paramètres'),
            ],
          ),
        );
      },
    );
  }
}
