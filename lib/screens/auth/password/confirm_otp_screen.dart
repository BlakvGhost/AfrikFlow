import 'dart:async';
import 'package:afrik_flow/services/auth_service.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/utils/format_utils.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/app_logo.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmOtpScreen extends ConsumerStatefulWidget {
  const ConfirmOtpScreen({super.key, required this.email});

  final String email;

  @override
  ConfirmOtpScreenState createState() => ConfirmOtpScreenState();
}

class ConfirmOtpScreenState extends ConsumerState<ConfirmOtpScreen> {
  TextEditingController pinController = TextEditingController();
  FocusNode pinFocusNode = FocusNode();
  Timer? countdownTimer;
  int remainingSeconds = emailVerificationRemainingSeconds;
  bool isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _handleAPI() async {
    if (pinController.text.isEmpty || pinController.text.length < 6) {
      showToast(context, "Veuillez bien saisir le code");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result =
        await _authService.verifyOtpCode(widget.email, pinController.text);

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      context.push('/reset-password', extra: {
        'email': widget.email.toString(),
        'otp': "${result['data']['data']['otp']}",
      });
    } else {
      showToast(context, result['message']);
    }
  }

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
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      remainingSeconds = emailVerificationRemainingSeconds;
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

  Future<void> resendCode() async {
    await _authService.sendPasswordResetEmail(widget.email);
    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 80),
              children: [
                const AppLogo(),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Réinitialiser votre mot de passe!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
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
                  onCompleted: (value) {
                    if (value.length == 6) {
                      FocusScope.of(context).unfocus();
                      _handleAPI();
                    }
                  },
                  onChanged: (value) {},
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    const Center(
                      child: Text(
                        "Vous n'avez pas reçu ?",
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
                const SizedBox(height: 10),
                CustomElevatedButton(
                  label: 'Confirmer',
                  onPressed: _handleAPI,
                  textColor: AppTheme.backgroundColor,
                  isLoading: isLoading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
