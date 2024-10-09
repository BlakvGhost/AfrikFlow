import 'package:afrik_flow/providers/user_notifier.dart';
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
  final Function(int)? onTabTapped;

  Future<AppBar?> getHomePageAppBar(double width, BuildContext context,
      WidgetRef ref, bool showAppBar, String? title) async {
    final user = ref.watch(userProvider);

    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: true,
      title: !showAppBar
          ? Text(
              title ?? 'AfrikFlow',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello ${user?.firstName}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Welcome back",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
      elevation: 22,
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
            backgroundImage: user?.avatar != null
                ? NetworkImage("${user?.avatar}")
                : const AssetImage('assets/images/man.png'),
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
        );
      },
    );
  }
}
