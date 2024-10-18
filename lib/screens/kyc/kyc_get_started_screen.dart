import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class KYCGetStartedScreen extends StatelessWidget {
  const KYCGetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/kyc.png',
            height: 180,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 32),
          const Text(
            'Vérifiez votre identité',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Veuillez soumettre les documents suivants pour traiter votre demande :',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildStep(
            context,
            icon: PhosphorIconsDuotone.identificationCard,
            title: 'Étape 1',
            description: 'Prenez une photo d\'une pièce d\'identité valide.',
          ),
          const SizedBox(height: 15),
          _buildStep(
            context,
            icon: PhosphorIconsDuotone.camera,
            title: 'Étape 2',
            description: 'Prenez un selfie pour confirmer votre identité.',
          ),
          const Spacer(),
          Text(
            'Vos informations seront cryptées et stockées en toute sécurité.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: () {
              context.push('/kyc');
            },
            label: 'Commencer',
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context,
      {required IconData icon,
      required String title,
      required String description}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
