import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  SendScreenState createState() => SendScreenState();
}

class SendScreenState extends State<SendScreen>
    with SingleTickerProviderStateMixin {
  String? selectedCountry;
  String? selectedOperator;
  List<String> operators = [];

  final Map<String, Map<String, dynamic>> countriesAndOperators = {
    'Bénin': {
      'code': "BJ",
      'operators': ['MTN', 'Celtiis', 'Moov'],
    },
    'Côte d’Ivoire': {
      'code': "CI",
      'operators': ['MTN', 'Orange', 'Moov'],
    },
    'Sénégal': {
      'code': "SN",
      'operators': ['Orange', 'Free', 'Expresso'],
    },
  };

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text('Envoyer de l\'argent'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color.fromARGB(255, 8, 50, 128),
          tabs: const [
            Tab(text: 'Transfert local'),
            Tab(text: 'Transfert par carte de crédit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLocalTransferContent(),
          _buildCreditCardTransfer(),
        ],
      ),
    );
  }

  Widget _buildLocalTransferContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSection("De :"),
            const SizedBox(height: 16),
            _buildCountryOperatorDropdown(),
            const SizedBox(height: 16),
            _buildPhoneNumberField('90 90 25 25'),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildAgreeSupportFees(),
            const SizedBox(height: 16),
            _buildSection("Vers :"),
            const SizedBox(height: 16),
            _buildCountryOperatorDropdown(),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildPhoneNumberField('96 96 96 96'),
            const SizedBox(height: 32),
            _buildFeesAndTotal(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardTransfer() {
    return const Center(
      child: Text(
        'Formulaire de transfert par carte de crédit',
        style: TextStyle(fontSize: 16, color: AppTheme.whiteColor),
      ),
    );
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
      ),
    );
  }

  Widget _buildCountryOperatorDropdown() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedCountry != null && selectedOperator != null
                ? '$selectedCountry - $selectedOperator'
                : null,
            hint: const Text('Choisir un pays et un opérateur'),
            onChanged: (value) {
              if (value != null) {
                final parts = value.split(' - ');
                setState(() {
                  selectedCountry = parts[0];
                  selectedOperator = parts[1];
                });
              }
            },
            items: countriesAndOperators.keys.expand((country) {
              final operators =
                  countriesAndOperators[country]!['operators'] as List<String>;
              return operators.map((operator) {
                return DropdownMenuItem<String>(
                  value: '$country - $operator',
                  child: Row(
                    children: [
                      Image.network(
                        "https://flagsapi.com/${countriesAndOperators[country]!['code']}/flat/64.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text('$country - $operator'),
                    ],
                  ),
                );
              });
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Pays et opérateur',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Montant',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixText: 'FCFA',
      ),
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

  Widget _buildAgreeSupportFees() {
    bool supportFees = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Je supporte les frais d'envoi",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Switch(
          value: supportFees,
          onChanged: (bool value) {
            setState(() {
              supportFees = value;
            });
          },
          activeColor: AppTheme.primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
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
        // SizedBox(height: 8),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       'MONTANT TOTAL',
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black,
        //       ),
        //     ),
        //     Text(
        //       '10 000 000 FCFA',
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.teal,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
