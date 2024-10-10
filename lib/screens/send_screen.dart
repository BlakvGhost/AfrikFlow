import 'package:afrik_flow/models/w_provider.dart';
import 'package:flutter/material.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/services/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});

  @override
  SendScreenState createState() => SendScreenState();
}

class SendScreenState extends ConsumerState<SendScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<WProvider>> _walletProvidersFuture;

  String? selectedCountry;
  String? selectedOperator;
  String? selectedCardType;
  List<String> operators = [];

  bool supportFees = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final transactionService = TransactionService(ref: ref);
    _walletProvidersFuture = transactionService.listWalletProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLocalTransferContent(),
          _buildCreditCardTransferContent(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 30,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
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
    );
  }

  Widget _buildTabButton(BuildContext context, int index, String text) {
    final isActive = _tabController.index == index;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() {
          _tabController.index = index;
        }),
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
    return FutureBuilder<List<WProvider>>(
      future: _walletProvidersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else {
          final walletProviders = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildSectionTitle("De :"),
                        const SizedBox(height: 16),
                        _buildCountryOperatorDropdown(walletProviders),
                        const SizedBox(height: 16),
                        _buildPhoneNumberField('90 90 25 25'),
                        const SizedBox(height: 16),
                        _buildAmountField(),
                        const SizedBox(height: 16),
                        _buildAgreeSupportFeesSwitch(),
                        const SizedBox(height: 16),
                        _buildSectionTitle("Vers :"),
                        const SizedBox(height: 16),
                        _buildCountryOperatorDropdown(walletProviders),
                        const SizedBox(height: 16),
                        _buildPhoneNumberField('96 96 96 96'),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildCreditCardTransferContent() {
    return FutureBuilder<List<WProvider>>(
      future: _walletProvidersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else {
          final walletProviders = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  _buildAgreeSupportFeesSwitch(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Vers :"),
                  const SizedBox(height: 16),
                  _buildCountryOperatorDropdown(walletProviders),
                  const SizedBox(height: 16),
                  _buildPhoneNumberField('96 96 96 96'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSectionTitle(String title) {
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

  Widget _buildCountryOperatorDropdown(List<WProvider> walletProviders) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedOperator,
      hint: const Text('Choisir un opérateur'),
      onChanged: (value) {
        if (value != null) {
          // final parts = value.split(' - ');
          setState(() {
            // selectedCountry = parts[0];
            selectedOperator = value;
          });
        }
      },
      items: walletProviders.map((provider) {
        return DropdownMenuItem<String>(
          value: "${provider.id}",
          child: Row(
            children: [
              Image.network(
                provider.country.flag,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(provider.name),
            ],
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Pays et opérateur',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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

  Widget _buildAgreeSupportFeesSwitch() {
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
        ),
      ],
    );
  }

  Widget _buildReasonDropdown() {
    final reasons = ['Frais de scolarité', 'Facture', 'Autre'];
    return DropdownButtonFormField<String>(
      hint: const Text("Raison de l'envoi"),
      onChanged: (value) {
        setState(() {
          // Handle selected reason
        });
      },
      items: reasons.map((reason) {
        return DropdownMenuItem<String>(
          value: reason,
          child: Text(reason),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Raison',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCardTypeSelection() {
    final cardTypes = ['Visa', 'MasterCard'];
    return DropdownButtonFormField<String>(
      hint: const Text("Type de carte"),
      onChanged: (value) {
        setState(() {
          selectedCardType = value;
        });
      },
      items: cardTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Type de carte',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
