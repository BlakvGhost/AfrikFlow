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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 20,
                    backgroundImage: const NetworkImage(
                        "https://media.licdn.com/dms/image/D4E12AQE8uOMdl4km9w/article-cover_image-shrink_600_2000/0/1678624190074?e=2147483647&v=beta&t=YEhO6rD75nuvHIg9za08JHadmzcjOyl-xBdtim_UnU4"),
                  ),
                  Positioned(
                    left: 22,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 20,
                      backgroundImage: const NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReoan3T0XNqnM9MJzptamAyMNNv70le5prnw&s"),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "De ${transaction.payinPhoneNumber} vers ${transaction.payoutPhoneNumber}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Par ${transaction.mode == 'local' ? 'transfert local' : 'carte de crédit'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          Text("XOF ${transaction.amountWithoutFees}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}
