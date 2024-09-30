import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      "date": "05/04/2024",
      "transactionId": "101578963",
      "amount": "350 000",
      "currency": "FCFA",
      "cardType": "Visa",
      "fromName": "Kabirou ALASSANE",
      "toName": "Elfried KIDJE",
      "fromOperator": "MTN",
      "toOperator": "Orange"
    },
    {
      "date": "05/04/2024",
      "transactionId": "101578963",
      "amount": "5 000",
      "currency": "FCFA",
      "cardType": "Visa",
      "fromName": "Souad Gaya",
      "toName": "Elfried KIDJE",
      "fromOperator": "MTN",
      "toOperator": "Orange"
    },
    {
      "date": "05/04/2024",
      "transactionId": "101578963",
      "amount": "5 000",
      "currency": "FCFA",
      "cardType": "Visa",
      "fromName": "Elfried KIDJE",
      "toName": "Elfried KIDJE",
      "fromOperator": "MTN",
      "toOperator": "Orange"
    },
  ];

  TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text('Historiques'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return _buildTransactionCard(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transaction['date'],
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white60),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Trans... ${transaction['transactionId']}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Text(
              '${transaction['amount']} ${transaction['currency']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 14),
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
                  transaction['fromName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Par ${transaction['cardType']}'),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
