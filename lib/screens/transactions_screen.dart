import 'package:flutter/material.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:afrik_flow/widgets/transaction_item.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String searchQuery = "";
  bool isRefreshing = false;
  bool isLoading = false;

  Future<void> _refresh() async {
    setState(() {
      isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData(ref);
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      ref.read(userProvider.notifier).refreshUserData(ref);
      setState(() {
        isLoading = false;
      });
    }

    final user = ref.watch(userProvider);
    final transactions = user?.transactions ?? [];

    final filteredTransactions = transactions.where((transaction) {
      final description =
          "De ${transaction.payinPhoneNumber} vers ${transaction.payoutPhoneNumber}";
      return description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          transaction.amount.toString().contains(searchQuery);
    }).toList();

    return RefreshIndicator(
      onRefresh: _refresh,
      child: isRefreshing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(PhosphorIconsDuotone.magnifyingGlass),
                          hintText: "Rechercher une transaction...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Historique des Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (filteredTransactions.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              PhosphorIconsDuotone.info,
                              color: Colors.grey[600],
                              size: 50,
                            ),
                            const SizedBox(height: 22),
                            Text(
                              "Aucune transaction trouvée.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: filteredTransactions
                            .map((transaction) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child:
                                      TransactionItem(transaction: transaction),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
