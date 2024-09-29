import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';

class SendScreen extends StatelessWidget {
  const SendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildSection("De :"),
          const SizedBox(height: 16),
          _buildAmountField(),
          const SizedBox(height: 16),
          _buildPhoneNumberField('90 90 25 25'),
          const SizedBox(height: 32),
          _buildSection("Vers :"),
          const SizedBox(height: 16),
          _buildAmountField(),
          const SizedBox(height: 16),
          _buildPhoneNumberField('96 96 96 96'),
          const SizedBox(height: 32),
          _buildFeesAndTotal(),
          const SizedBox(height: 24),
        ],
      ),
    ));
  }

  Widget _buildSection(String title) {
    return Center(
        child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.whiteColor,
      ),
    ));
  }

  Widget _buildAmountField() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.yellow[700],
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Montant',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixText: 'FCFA',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(String phoneNumber) {
    return TextFormField(
      initialValue: phoneNumber,
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildFeesAndTotal() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FRAIS A PRELEVER',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              '1 000 FCFA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
