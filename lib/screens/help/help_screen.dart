import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'question': 'Comment créer un compte ?',
      'answer':
          'Pour créer un compte, cliquez sur "Inscription" sur l\'écran de connexion, puis suivez les instructions. Assurez-vous d\'utiliser un e-mail valide.',
    },
    {
      'question': 'Comment réinitialiser mon mot de passe ?',
      'answer':
          'Cliquez sur "Mot de passe oublié" sur l\'écran de connexion et suivez les étapes pour réinitialiser votre mot de passe. Un lien de réinitialisation vous sera envoyé par e-mail.',
    },
    {
      'question': 'Quels sont les frais de transaction ?',
      'answer':
          'Les frais de transaction varient selon le montant et la destination. Consultez la section des frais dans l\'application pour obtenir des détails précis avant de valider vos transactions.',
    },
    {
      'question':
          'Comment puis-je activer l\'authentification à deux facteurs (2FA) ?',
      'answer':
          'Rendez-vous dans vos paramètres de sécurité et activez l\'authentification à deux facteurs pour ajouter une couche supplémentaire de protection à votre compte.',
    },
    {
      'question': 'Pourquoi mon paiement est-il en attente ?',
      'answer':
          'Les paiements peuvent rester en attente pour plusieurs raisons, telles que la vérification de votre identité ou des problèmes avec votre méthode de paiement. Consultez les détails de la transaction pour plus d\'informations.',
    },
    {
      'question': 'Comment puis-je contacter l\'assistance ?',
      'answer':
          'Vous pouvez nous contacter en utilisant le bouton d\'assistance en bas à droite de cet écran ou via la section "Contactez-nous" dans les paramètres de l\'application.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Divider(
                color: Colors.grey, thickness: 0.5, indent: 16, endIndent: 16),
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  final faq = faqList[index];
                  return _buildFAQItem(faq['question']!, faq['answer']!);
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              context.push('/assistance');
            },
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.support_agent, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Theme(
      data: ThemeData().copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: Colors.tealAccent,
        collapsedIconColor: Colors.grey,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
