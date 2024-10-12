import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KYCVerificationScreen extends ConsumerStatefulWidget {
  const KYCVerificationScreen({super.key});

  @override
  KYCVerificationScreenState createState() => KYCVerificationScreenState();
}

class KYCVerificationScreenState extends ConsumerState<KYCVerificationScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _errorMessage = null;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await ApiService().uploadImage(_selectedImage!, ref);

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      // showSucessToast(context, response['data']);
    } else {
      setState(() {
        _errorMessage = response['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final firstKyc = user!.kycs.isNotEmpty ? user.kycs.first : null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (firstKyc != null) ...[
            if (firstKyc.status == 'pending') ...[
              const Icon(
                Icons.hourglass_top,
                color: AppTheme.primaryColor,
                size: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                'Votre document est en cours de vérification, celà peu prendre un tout petit moment, vous serez informer une fois terminée...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (firstKyc.status == 'success') ...[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                'Votre document KYC a été approuvé!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (firstKyc.status == 'failed') ...[
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 16),
              Text(
                'Échec de la vérification: ${firstKyc.failureReason ?? 'Raison inconnue'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera, color: Colors.white),
                label: const Text(
                  'Reprendre une photo',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ]
          ] else ...[
            _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.file(
                      _selectedImage!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        color: AppTheme.primaryColor,
                        size: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Capturez une photo de votre carte d\'identité ou tout document justificatif pour la vérification KYC',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera, color: Colors.white),
              label: const Text(
                'Prendre une photo',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Assurez-vous que votre photo est bien claire pour la validation.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: _selectedImage != null ? _uploadImage : null,
              backgroundColor: _selectedImage != null
                  ? AppTheme.primaryColor
                  : Colors.grey.shade400,
              label: "Envoyer pour validation",
              isLoading: _isLoading,
            ),
          ],
          const SizedBox(height: 40),
          if (_errorMessage != null)
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
