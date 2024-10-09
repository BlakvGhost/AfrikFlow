import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:afrik_flow/widgets/carousel_with_dots.dart';
import 'package:afrik_flow/widgets/transaction_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isRefresh = false;

  Future<void> _refresh() async {
    setState(() {
      isRefresh = true;
    });
    await ref.read(userProvider.notifier).refreshUserData(ref);
    setState(() {
      isRefresh = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: isRefresh
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CarouselWithDots(),
                  const Padding(
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
                            icon: PhosphorIconsDuotone.dotsNine,
                            label: "Tous",
                            index: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Transactions overview section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transactions Récentes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(PhosphorIconsDuotone.magnifyingGlass),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        TransactionItem(),
                        TransactionItem(),
                        TransactionItem(),
                        TransactionItem(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
