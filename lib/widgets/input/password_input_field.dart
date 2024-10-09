import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PasswordInputField extends StatefulWidget {
  final String? label;
  final TextEditingController passwordController;

  const PasswordInputField(
      {super.key, required this.passwordController, this.label});

  @override
  PasswordInputFieldState createState() => PasswordInputFieldState();
}

class PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passwordController,
      obscureText: _isObscure,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(
        labelText: widget.label ?? 'Mot de passe',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure
                ? PhosphorIconsDuotone.eye
                : PhosphorIconsDuotone.eyeSlash,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
}
