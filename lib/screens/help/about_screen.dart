import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const ListTile(
                title: Text(
                  'Version de l\'application',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
                leading: Icon(Icons.info, color: AppTheme.primaryColor),
              ),
              ListTile(
                title: const Text(
                  'Conditions générales',
                  style: TextStyle(color: Colors.white),
                ),
                leading:
                    const Icon(Icons.description, color: AppTheme.primaryColor),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Politique de confidentialité',
                  style: TextStyle(color: Colors.white),
                ),
                leading:
                    const Icon(Icons.privacy_tip, color: AppTheme.primaryColor),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildAboutText(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Share.share('Découvrez cette super application AfrikFlow !');
            },
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.share, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AfrikFlow est une application révolutionnaire conçue pour simplifier vos transactions financières, que ce soit pour les paiements locaux ou internationaux. Nous avons à cœur de rendre les services financiers plus accessibles, rapides et sécurisés pour tous nos utilisateurs à travers l\'Afrique et au-delà.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 10),
        Text(
          'Caractéristiques principales :',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          '1. Transactions sécurisées et rapides : Grâce à nos technologies de cryptage de pointe, nous garantissons la sécurité de vos fonds et de vos données personnelles.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 5),
        Text(
          '2. Support des paiements mobiles et par carte : Que vous souhaitiez payer via votre portefeuille mobile ou avec une carte de crédit, AfrikFlow offre plusieurs moyens de paiement pour une flexibilité optimale.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 5),
        Text(
          '3. Suivi des transactions : Avec un historique détaillé de vos transactions, vous pouvez facilement garder une trace de vos paiements, recevoir des factures PDF et gérer vos finances de manière transparente.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 5),
        Text(
          '4. Notifications en temps réel : Recevez des notifications push pour chaque transaction, mise à jour de statut et plus encore, afin d\'être toujours au courant de vos activités financières.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 5),
        Text(
          '5. Sécurité renforcée avec 2FA : Pour protéger votre compte, activez l\'authentification à deux facteurs (2FA) et renforcez la sécurité de vos connexions.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 5),
        Text(
          '6. Support multilingue : AfrikFlow est disponible dans plusieurs langues afin de faciliter son utilisation par les utilisateurs dans différentes régions.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 10),
        Text(
          'Pourquoi choisir AfrikFlow ?',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          '• Innovation et Simplicité : Nous avons conçu AfrikFlow pour qu\'il soit simple d\'utilisation tout en offrant des fonctionnalités puissantes. Que vous soyez un particulier ou une entreprise, nos solutions s\'adaptent à vos besoins.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 5),
        Text(
          '• Adapté aux besoins africains : Nous comprenons les spécificités des marchés africains et avons conçu l\'application en tenant compte de ces réalités, avec des partenariats locaux qui facilitent les transactions.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 5),
        Text(
          '• Un engagement pour l\'inclusion financière : Nous voulons rendre les services financiers accessibles à un plus grand nombre de personnes, y compris ceux qui n\'ont pas accès aux services bancaires traditionnels.',
          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}
