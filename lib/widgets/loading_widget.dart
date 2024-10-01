import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;

  // ignore: use_super_parameters
  const LoadingWidget({required this.isLoading, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink(); // Pas de loader si isLoading est false
    }

    return const Stack(
      children: [
        // Couche d'opacité
        Opacity(
          opacity: 0.8,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        ),
        // Loader au centre
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
