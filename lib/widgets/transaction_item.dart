import 'package:afrik_flow/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/transaction-details', extra: transaction);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 20,
                      backgroundImage:
                          NetworkImage(transaction.payinWProvider.logo),
                    ),
                    Positioned(
                      left: 22,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 20,
                        backgroundImage:
                            NetworkImage(transaction.payoutWProvider.logo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vers ${transaction.payoutPhoneNumber} par ${transaction.payinPhoneNumber}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Par ${transaction.mode == 'local' ? 'transfert local' : 'carte de crédit'}',
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Status with Icon
                Row(
                  children: [
                    Icon(
                      transaction.payinStatus == 'success' &&
                              transaction.payoutStatus == 'success'
                          ? Icons.check_circle
                          : transaction.payinStatus == 'pending' ||
                                  transaction.payoutStatus == 'success'
                              ? Icons.hourglass_empty
                              : Icons.error,
                      color: transaction.payinStatus == 'success' &&
                              transaction.payoutStatus == 'success'
                          ? Colors.green
                          : transaction.payinStatus == 'pending' ||
                                  transaction.payoutStatus == 'pending'
                              ? Colors.orange
                              : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      transaction.payinStatus == 'success' &&
                              transaction.payoutStatus == 'success'
                          ? 'Réussi'
                          : transaction.payinStatus == 'pending' ||
                                  transaction.payoutStatus == 'pending'
                              ? 'En attente'
                              : 'Échoué',
                      style: TextStyle(
                        color: transaction.payinStatus == 'success' &&
                                transaction.payoutStatus == 'success'
                            ? Colors.green
                            : transaction.payinStatus == 'pending' ||
                                    transaction.payoutStatus == 'pending'
                                ? Colors.orange
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transaction.humarizeDate,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "F CFA ${transaction.amountWithoutFees}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
