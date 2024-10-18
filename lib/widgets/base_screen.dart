import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BaseScreen extends ConsumerStatefulWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;
  final bool isFullScreen;
  final Widget? floatingActionButton;
  final Function(int)? onTabTapped;

  const BaseScreen({
    super.key,
    required this.child,
    this.title,
    this.showAppBar = true,
    this.floatingActionButton,
    this.onTabTapped,
    this.isFullScreen = false,
  });

  @override
  ConsumerState<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final appBar = !widget.isFullScreen
        ? AppBar(
            toolbarHeight: 80,
            automaticallyImplyLeading: true,
            title: !widget.showAppBar
                ? Text(
                    widget.title ?? 'AfrikFlow',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello ${user?.firstName ?? 'Guest'}",
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
                icon: Stack(
                  children: user?.notifications.isEmpty ?? true
                      ? [
                          const PhIcon(
                            child: PhosphorIconsDuotone.bell,
                            isWhite: true,
                            smartColor: true,
                          ),
                        ]
                      : [
                          const PhIcon(
                            child: PhosphorIconsDuotone.bellRinging,
                            isWhite: true,
                            smartColor: true,
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 15,
                                minHeight: 15,
                              ),
                              child: Text(
                                user!.notifications.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                ),
                onPressed: () {
                  context.push('/notifications');
                },
              ),
              IconButton(
                icon: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(user?.avatar ?? ''),
                ),
                onPressed: () {
                  context.push('/profile');
                },
              ),
            ],
          )
        : null;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(child: widget.child),
      floatingActionButton: widget.floatingActionButton,
      extendBody: true,
    );
  }
}
