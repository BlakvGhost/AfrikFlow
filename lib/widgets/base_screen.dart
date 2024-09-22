import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;
  final Widget? floatingActionButton;
  final int? currentIndex;
  final Function(int)? onTabTapped;

  AppBar getHomePageAppBar(double width, double height) {
    return showAppBar
        ? AppBar(
            title: Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: width * 0.4,
            ),
            centerTitle: true,
            elevation: 18,
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
    this.currentIndex,
    this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: getHomePageAppBar(screenWidth, screenHeight),
      body: child,
      floatingActionButton: floatingActionButton,
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(title: const Text('Accueil'), onTap: () {}),
            ListTile(title: const Text('Transactions'), onTap: () {}),
          ],
        ),
      ),
      bottomNavigationBar: currentIndex != null
          ? BottomNavigationBar(
              currentIndex: currentIndex!,
              onTap: onTabTapped,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Accueil'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.payment), label: 'Transactions'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'Profil'),
              ],
            )
          : null,
    );
  }
}
