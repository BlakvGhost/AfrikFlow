import 'package:afrik_flow/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:afrik_flow/widgets/carousel_with_dots.dart';
import 'package:afrik_flow/widgets/transaction_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselWithDots(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleButton(
                    icon: PhosphorIconsDuotone.paperPlaneTilt,
                    label: "Envoyer",
                    index: 1),
                CircleButton(
                    icon: PhosphorIconsDuotone.fileText,
                    label: "Facture",
                    index: 2),
                CircleButton(
                    icon: PhosphorIconsDuotone.clockCounterClockwise,
                    label: "Historiques",
                    index: 3),
                CircleButton(
                    icon: PhosphorIconsDuotone.gearSix,
                    label: "Paramètre",
                    index: 4),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleButton(
                    icon: PhosphorIconsDuotone.userCircleGear,
                    label: "Profile",
                    index: 5),
                CircleButton(
                    icon: PhosphorIconsDuotone.notification,
                    label: "Notifications",
                    index: 6),
                CircleButton(
                    icon: PhosphorIconsDuotone.fileText,
                    label: "Assistance",
                    index: 7),
                CircleButton(
                    icon: PhosphorIconsDuotone.dotsNine,
                    label: "Tous",
                    index: 8),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Transactions overview section
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Transactions Récentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Sample transactions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TransactionItem(
                  title: 'Spotify Music',
                  amount: 'XOF 168',
                  date: '5 Aug, 2022',
                  time: '6:40 PM',
                ),
                TransactionItem(
                  title: 'Github Brand',
                  amount: 'XOF 168',
                  date: '2 Aug, 2022',
                  time: '12:56 PM',
                ),
                TransactionItem(
                  title: 'Dropbox Pro',
                  amount: 'XOF 299',
                  date: '22 Jul, 2022',
                  time: '11:32 AM',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
