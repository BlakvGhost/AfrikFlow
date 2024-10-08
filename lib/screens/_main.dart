import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header Section
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Rakib",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Welcome back",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 25,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Slideshow Section
            SizedBox(
              height: 200,
              child: PageView(
                children: const [
                  CardWidget(
                    cardType: "MasterCard",
                    amount: "20,340.98",
                    cardNumber: "**** 8902",
                  ),
                  CardWidget(
                    cardType: "Apple Pay",
                    amount: "15,560.23",
                    cardNumber: "**** 6838",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.receipt, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.phone_android, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Transactions Section
            const Text(
              "Transactions",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            const TransactionItem(title: "Spotify Music", amount: "\$168"),
            const TransactionItem(title: "GitHub Brand", amount: "\$168"),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String cardType;
  final String amount;
  final String cardNumber;

  const CardWidget({super.key, required this.cardType, required this.amount, required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cardType, style: const TextStyle(color: Colors.white, fontSize: 18)),
          const Spacer(),
          Text("\$$amount", style: const TextStyle(color: Colors.white, fontSize: 32)),
          const SizedBox(height: 10),
          Text(cardNumber, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String amount;

  const TransactionItem({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_money, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
