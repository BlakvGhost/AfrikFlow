import 'package:afrik_flow/widgets/card/stat_card.dart';
import 'package:afrik_flow/widgets/transaction_overview_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> transactionsPerMonth = [
      5000,
      7000,
      3000,
      10000,
      15000,
      4000,
      6000,
      8000,
      5000,
      12000,
      9000,
      7000
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: [
              Image.asset(
                'assets/onboard/onboard1.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              Image.asset(
                'assets/onboard/onboard2.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ],
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 8),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Récapitulatif du compte',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: const [
                StatCard(
                  title: 'Montant Total',
                  value: 'XOF 10,000',
                  icon: PhosphorIconsDuotone.currencyCircleDollar,
                ),
                StatCard(
                  title: 'Montant du Mois',
                  value: 'XOF 2,500',
                  icon: PhosphorIconsDuotone.coins,
                ),
                StatCard(
                  title: 'Transactions Totales',
                  value: '120',
                  icon: PhosphorIconsDuotone.swap,
                ),
                StatCard(
                  title: 'Transactions du Mois',
                  value: '30',
                  icon: PhosphorIconsDuotone.trendUp,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aperçu des Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TransactionOverviewChart(
                  transactionsPerMonth: transactionsPerMonth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
