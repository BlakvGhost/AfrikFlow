import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isRefresh = false;

  Future<void> _refresh() async {
    setState(() {
      isRefresh = true;
    });
    await ref.read(userProvider.notifier).refreshUserData(ref);
    setState(() {
      isRefresh = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: isRefresh
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user?.avatar != null
                              ? NetworkImage("${user?.avatar}")
                              : const AssetImage('assets/images/man.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(PhosphorIconsDuotone.camera,
                                color: AppTheme.primaryColor),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(PhosphorIconsDuotone.userCircle),
                      title: Text("${user?.firstName} ${user?.lastName}"),
                      trailing: IconButton(
                        icon: const Icon(PhosphorIconsDuotone.pencilSimple),
                        onPressed: () {},
                      ),
                    ),
                    ListTile(
                      leading: const Icon(PhosphorIconsDuotone.envelope),
                      title: Text(user!.email),
                      trailing: IconButton(
                        icon: const Icon(PhosphorIconsDuotone.pencilSimple),
                        onPressed: () {},
                      ),
                    ),
                    ListTile(
                      leading: const Icon(PhosphorIconsDuotone.phone),
                      title: Text(user.phoneNumber),
                      trailing: IconButton(
                        icon: const Icon(PhosphorIconsDuotone.pencilSimple),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showLogoutConfirmation(context, ref);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            "Se déconnecter",
                            style: TextStyle(color: AppTheme.whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                await ref.read(userProvider.notifier).logout();

                context.go('/login');
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }
}
