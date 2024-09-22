import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;
  final Widget? floatingActionButton;
  final int? currentIndex;
  final Function(int)? onTabTapped;

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
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? 'AfrikFlow'),
            )
          : null,
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
