import 'package:afrik_flow/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AllServiceScreen extends StatelessWidget {
  const AllServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
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
          ],
        ),
      ),
    );
  }
}
