import 'package:afrik_flow/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    backgroundImage: const NetworkImage(
                      "https://media.licdn.com/dms/image/D4E12AQE8uOMdl4km9w/article-cover_image-shrink_600_2000/0/1678624190074?e=2147483647&v=beta&t=YEhO6rD75nuvHIg9za08JHadmzcjOyl-xBdtim_UnU4",
                    ),
                  ),
                  Positioned(
                    left: 22,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 20,
                      backgroundImage: const NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReoan3T0XNqnM9MJzptamAyMNNv70le5prnw&s",
                      ),
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
                      "De ${transaction.payinPhoneNumber} vers ${transaction.payoutPhoneNumber}",
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
    );
  }
}
