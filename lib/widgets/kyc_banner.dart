import 'package:afrik_flow/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KycBanner extends StatelessWidget {
  final User user;

  const KycBanner({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final firstKyc = user.kycs.isNotEmpty ? user.kycs.first : null;

    if (!user.isVerified && firstKyc?.status != 'success') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                firstKyc == null
                    ? 'Votre compte n\'est pas encore vérifié. Veuillez compléter la vérification pour accéder à tous les services.'
                    : (firstKyc.status == 'pending'
                        ? "Votre compte est en cours de validation"
                        : "La validation de votre compte a échouée"),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                context.push('/kyc');
              },
              child: const Text(
                'Vérifier',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
