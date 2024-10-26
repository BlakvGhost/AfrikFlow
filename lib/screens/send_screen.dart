import 'package:afrik_flow/models/user.dart';
import 'package:afrik_flow/models/w_provider.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/services/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slide_action/slide_action.dart';
import 'package:go_router/go_router.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});

  @override
  SendScreenState createState() => SendScreenState();
}

class SendScreenState extends ConsumerState<SendScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TransactionService _transactionService;

  String? selectedPayinOperator;
  String? selectedPayoutOperator;
  String? selectedCardType;
  List<String> operators = [];
  List<WProvider>? walletProviders;

  double totalSendAmount = 0.0;
  double totalAmount = 0.0;

  bool supportFees = false;

  bool isProcessing = false;

  final TextEditingController _payinPhoneNumberController =
      TextEditingController();
  final TextEditingController _payoutPhoneNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<void> _loadWalletProviders() async {
    final providers = await _transactionService.listWalletProviders();

    if (mounted) {
      setState(() {
        walletProviders = providers;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _transactionService = TransactionService(ref: ref);
    _loadWalletProviders();
  }

  @override
  void dispose() {
    _payinPhoneNumberController.dispose();
    _payoutPhoneNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _calculateFees() async {
    if (selectedPayinOperator != null &&
        selectedPayoutOperator != null &&
        totalAmount >= 500) {
      final response = await _transactionService.calculateFees(
        payinWProviderId: selectedPayinOperator!,
        payoutWProviderId: selectedPayoutOperator!,
        amount: double.parse(_amountController.text),
        senderSupportFee: supportFees,
      );

      if (response['success']) {
        setState(() {
          totalSendAmount =
              double.parse("${response['data']['amountWithoutFees']}");
          totalAmount = double.parse("${response['data']['amountWithFees']}");
        });
      }
    }
  }

  Future<void> _confirmAndSendTransaction() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Wrap(
            children: [
              Text(
                'Confirmation de transaction',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            // Ajout d'un SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Détails de la transaction :',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total à payer :',
                        style: TextStyle(color: Colors.white)),
                    Text('$totalAmount FCFA',
                        style: const TextStyle(color: Colors.greenAccent)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total à recevoir :',
                        style: TextStyle(color: Colors.white)),
                    Text('$totalSendAmount FCFA',
                        style: const TextStyle(color: Colors.greenAccent)),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    Text(
                      'Voulez-vous envoyer de ${_payinPhoneNumberController.text} vers ${_payoutPhoneNumberController.text} ?',
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextButton.icon(
                    icon: const Icon(Icons.cancel, color: Colors.redAccent),
                    label: const Text(
                      'Annuler',
                      style: TextStyle(color: Colors.redAccent),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text(
                      'Confirmer',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == true && _canSlide()) {
      setState(() {
        isProcessing = true;
      });

      final sendResponse = await _transactionService.sendTransaction(
        payinPhoneNumber: _payinPhoneNumberController.text,
        payinWProviderId: selectedPayinOperator!,
        payoutPhoneNumber: _payoutPhoneNumberController.text,
        payoutWProviderId: selectedPayoutOperator!,
        amount: double.parse(_amountController.text),
        senderSupportFee: supportFees,
      );
      setState(() {
        isProcessing = false;
      });

      if (sendResponse['success']) {
        context.push('/transactions');
      } else {
        showToast(context, sendResponse['message']);
      }
    }
  }

  bool _canSlide() {
    return selectedPayinOperator != null &&
        selectedPayoutOperator != null &&
        _payinPhoneNumberController.text.isNotEmpty &&
        _payoutPhoneNumberController.text.isNotEmpty &&
        _amountController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: isProcessing
            ? [const Center(child: CircularProgressIndicator())]
            : [
                _buildLocalTransferContent(user!),
                _buildCreditCardTransferContent(user),
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

  Widget _buildLocalTransferContent(User user) {
    if (walletProviders == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  _buildCountryOperatorDropdown(walletProviders!, true),
                  const SizedBox(height: 16),
                  _buildPhoneNumberField(_payinPhoneNumberController),
                  const SizedBox(height: 16),
                  _buildAmountField(user),
                  const SizedBox(height: 16),
                  _buildAgreeSupportFeesSwitch(),
                  const SizedBox(height: 10),
                  _buildSectionTitle("Vers :"),
                  const SizedBox(height: 16),
                  _buildCountryOperatorDropdown(walletProviders!, false),
                  const SizedBox(height: 16),
                  _buildPhoneNumberField(_payoutPhoneNumberController),
                  _buildSlideButton(user),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreditCardTransferContent(User user) {
    if (walletProviders == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildReasonDropdown(),
            const SizedBox(height: 16),
            _buildAmountField(user),
            const SizedBox(height: 16),
            _buildCardTypeSelection(),
            const SizedBox(height: 16),
            _buildAgreeSupportFeesSwitch(),
            const SizedBox(height: 24),
            _buildSectionTitle("Vers :"),
            const SizedBox(height: 16),
            _buildCountryOperatorDropdown(walletProviders!, false),
            const SizedBox(height: 16),
            _buildPhoneNumberField(_payoutPhoneNumberController),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideButton(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
      child: SlideAction(
        trackBuilder: (context, state) {
          return Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              'Glisser pour envoyer $totalAmount FCFA',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        thumbBuilder: (context, state) {
          return Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          );
        },
        action: () {
          if (!user.isVerified) {
            showToast(context,
                "Votre compte n'est pas encore vérifié. Veuillez compléter la vérification pour accéder à ce service.");
          } else {
            if (_canSlide()) {
              if (double.parse(_amountController.text) < 500) {
                showToast(
                    context, "Le montant minimun d'envoi est de 500 FCFA");
              } else {
                _confirmAndSendTransaction();
              }
            } else {
              showToast(
                  context, "Veuillez remplir tous les champs nécessaires");
            }
          }
        },
        actionSnapThreshold: 0.85,
      ),
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

  Widget _buildCountryOperatorDropdown(
      List<WProvider> walletProviders, bool isPayin) {
    final Map<String, List<WProvider>> providersByCountry = {};
    for (var provider in walletProviders) {
      providersByCountry
          .putIfAbsent(provider.country.slug, () => [])
          .add(provider);
    }

    final selectedProvider = walletProviders
        .where((provider) =>
            provider.id.toString() ==
            (isPayin ? selectedPayinOperator : selectedPayoutOperator))
        .firstOrNull;

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: isPayin ? selectedPayinOperator : selectedPayoutOperator,
      hint: selectedProvider != null
          ? Row(
              children: [
                Image.network(
                  selectedProvider.country.flag,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                    '${selectedProvider.country.code} - ${selectedProvider.name}'),
              ],
            )
          : const Text('Choisir un opérateur'),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            if (isPayin) {
              selectedPayinOperator = value;
            } else {
              selectedPayoutOperator = value;
            }
          });
          _calculateFees();
        }
      },
      items: providersByCountry.entries.expand((entry) {
        final countryName = entry.key;
        final providers = entry.value;

        return [
          DropdownMenuItem<String>(
            value: null,
            enabled: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                countryName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ...providers.map((provider) {
            final isSelected = provider.id.toString() ==
                (isPayin ? selectedPayinOperator : selectedPayoutOperator);

            return DropdownMenuItem<String>(
              value: "${provider.id}",
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Image.network(
                      provider.logo,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check, color: Colors.green),
                    ],
                  ],
                ),
              ),
            );
          }),
        ];
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Pays et opérateur',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildAmountField(User user) {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Montant',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixText: 'FCFA',
      ),
      onChanged: (value) {
        totalAmount = double.parse(value);
        _calculateFees();
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPhoneNumberField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textInputAction: TextInputAction.next,
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
            _calculateFees();
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
        setState(() {});
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
