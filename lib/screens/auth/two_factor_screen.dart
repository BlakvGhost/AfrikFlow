import 'dart:async';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/utils/format_utils.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:afrik_flow/widgets/ui/auth_screen_bottom_cgu.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key, required this.email});

  final String email;

  @override
  TwoFactorScreenState createState() => TwoFactorScreenState();
}

class TwoFactorScreenState extends State<TwoFactorScreen> {
  TextEditingController pinController = TextEditingController();
  FocusNode pinFocusNode = FocusNode();
  Timer? countdownTimer;
  int remainingSeconds = twoFactorEmailVerificationRemainingSeconds;

  @override
  void initState() {
    super.initState();
    startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(pinFocusNode);
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();

    if (pinFocusNode.hasFocus) {
      pinFocusNode.unfocus();
    }

    if (mounted) {
      // pinController.dispose();
    }
    // pinFocusNode.dispose();

    super.dispose();
  }

  void startCountdown() {
    setState(() {
      remainingSeconds = twoFactorEmailVerificationRemainingSeconds;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void resendCode() {
    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 120),
              children: [
                const Center(
                  child: Text(
                    'Authentification à double facteurs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Veuillez entrer le code de vérification reçu sur ${widget.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  focusNode: pinFocusNode,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.grey.shade200,
                    inactiveFillColor: Colors.grey.shade100,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: pinController,
                  onChanged: (value) {},
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        const Center(
                          child: Text(
                            "Vous n'avez pas reçu le code ?",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: remainingSeconds > 0 ? null : resendCode,
                          child: Text(
                            "Renvoyer (${formatDuration(remainingSeconds)})",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        //
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  label: 'Confirmer',
                  onPressed: () {
                    if (mounted) {
                      FocusScope.of(context).requestFocus(pinFocusNode);
                      context.go('/home');
                    }
                  },
                  textColor: AppTheme.backgroundColor,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const AuthScreenBottomCgu(),
        ],
      ),
    );
  }
}
