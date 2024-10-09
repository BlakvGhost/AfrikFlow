import 'package:flutter/material.dart';

class AuthScreenBottomCgu extends StatelessWidget {
  const AuthScreenBottomCgu({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'En vous inscrivant vous acceptez notre '),
            TextSpan(
              text: 'politique de confidentialité',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            TextSpan(text: ' & '),
            TextSpan(
              text: 'Nos termes et conditions.',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
