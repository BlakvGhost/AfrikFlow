import 'package:afrik_flow/widgets/card/stat_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aperçu des Transactions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 1:
                              return const Text('Jan');
                            case 2:
                              return const Text('Fév');
                            case 3:
                              return const Text('Mar');
                            case 4:
                              return const Text('Avr');
                            case 5:
                              return const Text('Mai');
                            case 6:
                              return const Text('Juin');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(1, 1500),
                        FlSpot(2, 2000),
                        FlSpot(3, 3000),
                        FlSpot(4, 2500),
                        FlSpot(5, 3500),
                        FlSpot(6, 4000),
                      ],
                      isCurved: true,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
