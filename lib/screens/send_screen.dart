import 'package:flutter/material.dart';
import 'package:afrik_flow/themes/app_theme.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  SendScreenState createState() => SendScreenState();
}

class SendScreenState extends State<SendScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  String? selectedCountry;
  String? selectedOperator;
  String? selectedCardType;
  List<String> operators = [];

  bool supportFees = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppTheme.primaryColor.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabButton(context, 0, 'Local'),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildTabButton(context, 1, 'Carte de crédit'),
                ],
              ),
            ),
          ),
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

  Widget _buildTabButton(BuildContext context, int index, String text) {
    final isActive = _tabController.index == index;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _tabController.index = index;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: isActive
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.1),
          foregroundColor: isActive ? Colors.white : AppTheme.primaryColor,
          elevation: isActive ? 5 : 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardTransfer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildReasonDropdown(),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildCardTypeSelection(),
            const SizedBox(height: 16),
            _buildAgreeSupportFees(),
            const SizedBox(height: 24),
            _buildSection("Vers :"),
            const SizedBox(height: 16),
            _buildCountryOperatorDropdown(),
            const SizedBox(height: 16),
            _buildPhoneNumberField('96 96 96 96'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonDropdown() {
    List<String> reasons = [
      "Aide familiale",
      "Paiement de facture",
      "Cadeau",
      "Autre",
    ];

    String? selectedReason;

    return DropdownButtonFormField<String>(
      value: selectedReason,
      hint: const Text('Sélectionnez une raison'),
      decoration: InputDecoration(
        labelText: 'Raison d\'envoi',
        labelStyle: const TextStyle(color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        setState(() {
          selectedReason = value;
        });
      },
      items: reasons.map((reason) {
        return DropdownMenuItem<String>(
          value: reason,
          child: Text(reason),
        );
      }).toList(),
    );
  }

  Widget _buildCardTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type de carte',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: RadioListTile<String>(
                title: const Text("Visa"),
                value: 'Visa',
                groupValue: selectedCardType,
                onChanged: (value) {
                  setState(() {
                    selectedCardType = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
            Flexible(
              child: RadioListTile<String>(
                title: const Text("Mastercard"),
                value: 'Mastercard',
                groupValue: selectedCardType,
                onChanged: (value) {
                  setState(() {
                    selectedCardType = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ],
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
      keyboardType: TextInputType.number,
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
}
