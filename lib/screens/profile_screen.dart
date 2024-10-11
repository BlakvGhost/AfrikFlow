import 'package:afrik_flow/models/log.dart';
import 'package:afrik_flow/models/user.dart';
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

  Widget buildVerifiedIcon(User? user) {
    return user?.isVerified ?? false
        ? const Icon(
            PhosphorIconsDuotone.checkCircle,
            color: Colors.green,
            size: 24,
          )
        : const Icon(
            PhosphorIconsDuotone.warning,
            color: Colors.red,
            size: 24,
          );
  }

  void editName(User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String firstName = user?.firstName ?? '';
        String lastName = user?.lastName ?? '';
        return AlertDialog(
          title: const Text('Modifier le nom'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Prénom'),
                controller: TextEditingController(text: firstName),
                onChanged: (value) => firstName = value,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                controller: TextEditingController(text: lastName),
                onChanged: (value) => lastName = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Widget buildActivityHistory(List<Log> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Historique des activités",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            String actionMessage;
            IconData icon;

            switch (logs[index].action) {
              case 'login':
                actionMessage = 'Vous vous êtes connecté.';
                icon = PhosphorIconsDuotone.signIn;
                break;
              case 'register':
                actionMessage = 'Vous vous êtes inscrit.';
                icon = PhosphorIconsDuotone.userPlus;
                break;
              case 'transfer':
                actionMessage = 'Vous avez effectué un transfert.';
                icon = PhosphorIconsDuotone.arrowRight;
                break;
              default:
                actionMessage = logs[index].action;
                icon = PhosphorIconsDuotone.info;
            }

            return ListTile(
              leading: Icon(icon),
              title: Text(actionMessage),
              subtitle: Text(logs[index].humarizeDate),
              trailing: Text(logs[index].city),
            );
          },
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 18,
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  PhosphorIconsDuotone.userSwitch,
                  size: 35,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Confirmer la déconnexion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Êtes-vous sûr de vouloir vous déconnecter ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          await ref.read(userProvider.notifier).logout();

                          context.go('/login');
                        },
                        child: const Text('Confirmer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final logs = user?.logs.take(10).toList();

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
                          backgroundImage: NetworkImage(user?.avatar ?? ''),
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
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: buildVerifiedIcon(user),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(PhosphorIconsDuotone.userCircle),
                      title: Text("${user?.firstName} ${user?.lastName}"),
                      trailing: IconButton(
                        icon: const Icon(PhosphorIconsDuotone.pencilSimple),
                        onPressed: () => editName(user),
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
                    buildActivityHistory(logs!),
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
}
