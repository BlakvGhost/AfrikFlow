import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class KYCVerificationScreen extends ConsumerStatefulWidget {
  const KYCVerificationScreen({super.key});

  @override
  KYCVerificationScreenState createState() => KYCVerificationScreenState();
}

class KYCVerificationScreenState extends ConsumerState<KYCVerificationScreen> {
  File? _selfieImage;
  File? _documentImage;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
        _errorMessage = null;
      });
    }
  }

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _documentImage = File(pickedFile.path);
        _errorMessage = null;
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_selfieImage == null || _documentImage == null || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final compressedSelfie = await compute(compressImageInBackground, _selfieImage!);
      final compressedDocument = await compute(compressImageInBackground, _documentImage!);
      final responseSelfie = await ApiService().uploadImage(compressedSelfie, ref);
      final responseDocument = await ApiService().uploadImage(compressedDocument, ref);

      setState(() {
        _isLoading = false;
        _errorMessage = responseSelfie['success'] && responseDocument['success']
            ? null
            : 'Échec de l\'envoi. Veuillez réessayer.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors de l\'envoi. Veuillez réessayer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImageSection(
            title: 'Selfie Photo',
            subtitle: 'Selfie with your front camera to verify your identity',
            image: _selfieImage,
            onTap: _pickSelfie,
          ),
          const SizedBox(height: 16),
          _buildImageSection(
            title: 'Passport Scan',
            subtitle: 'Take a passport or ID to check your information',
            image: _documentImage,
            onTap: _pickDocument,
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            onPressed: _selfieImage != null && _documentImage != null && !_isLoading
                ? _uploadImages
                : null,
            backgroundColor: _selfieImage != null && _documentImage != null
                ? AppTheme.primaryColor
                : Colors.grey.shade400,
            label: "Submit all",
            isLoading: _isLoading,
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection({
    required String title,
    required String subtitle,
    File? image,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      image,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: AppTheme.primaryColor, size: 60),
                      SizedBox(height: 16),
                      Text(
                        'Upload',
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
