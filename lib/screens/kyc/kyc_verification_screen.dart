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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _selectedImage != null
              ? Image.file(_selectedImage!)
              : const Text('Aucune image sélectionnée.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: const Text('Prendre une photo'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: const Text('Choisir depuis la galerie'),
          ),
        ],
      ),
    );
  }
}
