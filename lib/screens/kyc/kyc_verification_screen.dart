import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KYCVerificationScreen extends ConsumerStatefulWidget {
  const KYCVerificationScreen({super.key});

  @override
  ConsumerState<KYCVerificationScreen> createState() =>
      _KYCVerificationScreenState();
}

class _KYCVerificationScreenState extends ConsumerState<KYCVerificationScreen> {
  File? _selfieImage;
  File? _documentImage;
  bool _isLoading = false;

  Future<void> _pickSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _documentImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_selfieImage == null || _documentImage == null || _isLoading) {
      return showToast(context, "Veuillez prendre les deux images");
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final compressedLegalDocImage =
          await compute(compressImageInBackground, _documentImage!);
      final compressedSelfieImage =
          await compute(compressImageInBackground, _selfieImage!);
      final res = await ApiService()
          .uploadImage(compressedLegalDocImage, compressedSelfieImage, ref);

      setState(() {
        _isLoading = false;
      });

      if (!res['success']) {
        showToast(context, res['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final firstKyc = user!.kycs.isNotEmpty ? user.kycs.first : null;

    if (firstKyc != null && firstKyc.status == 'success') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Vérification KYC réussie'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Votre KYC a été vérifié avec succès.',
            style: TextStyle(color: Colors.green, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification KYC'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Veuillez suivre les étapes ci-dessous pour terminer la vérification KYC.',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              _buildStepCard(
                title: 'Selfie Photo',
                description:
                    'Prenez un selfie avec votre caméra frontale pour vérifier votre identité.',
                imagePath: 'assets/images/step1.png',
                buttonText:
                    _selfieImage != null ? 'Selfie pris' : 'Prendre le selfie',
                onTap: _selfieImage == null ? _pickSelfie : null,
                isCompleted: _selfieImage != null,
              ),
              const SizedBox(height: 38),
              _buildStepCard(
                title: 'Scan du Document',
                description:
                    'Prenez une photo de votre passeport ou de votre carte d\'identité pour vérifier vos informations.',
                imagePath: 'assets/images/step2.png',
                buttonText: _documentImage != null
                    ? 'Document pris'
                    : 'Prendre la carte',
                onTap: _documentImage == null ? _pickDocument : null,
                isCompleted: _documentImage != null,
              ),
              const SizedBox(height: 28),
              CustomElevatedButton(
                label: "Soumettre tout",
                onPressed: _isLoading ? null : _uploadImages,
                isLoading: _isLoading,
              ),
              if (firstKyc != null && firstKyc.status == 'failed')
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Échec à l\'étape : ${firstKyc.failedStep}\nRaison: ${firstKyc.failureReason}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String title,
    required String description,
    required String imagePath,
    required String buttonText,
    required VoidCallback? onTap,
    required bool isCompleted,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          color: isCompleted ? Colors.green[800] : Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(PhosphorIconsDuotone.camera),
                  label: Text(buttonText),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: isCompleted
                        ? Colors.green
                        : Colors.black26, // Coloration
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
