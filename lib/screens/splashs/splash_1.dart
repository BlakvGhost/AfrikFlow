import 'package:afrik_flow/widgets/auth_base_screen.dart';
import 'package:flutter/material.dart';

class Splash1 extends StatelessWidget {
  const Splash1({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBaseScreen(child: Image.asset('assets/splash/splash_1.png'));
  }
}
