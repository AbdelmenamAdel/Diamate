import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage(ImageSource source) async {
  final XFile? image = await ImagePicker().pickImage(source: source);
  if (image != null) {
    return image;
  } else {
    return null;
  }
}

Future<List<XFile>?> pickMultipleImages() async {
  final List<XFile> images = await ImagePicker().pickMultiImage();
  return images;
}

Future<File?> pickImageWithFile(ImageSource source) async {
  try {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('Error picking image: $e');
    return null;
  }
}

Future<String?> convertFileToBase64(File file) async {
  try {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  } catch (e) {
    return null;
  }
}

Future<String> assetImageToBase64(String image) async {
  ByteData data = await rootBundle.load(image);
  Uint8List bytes = data.buffer.asUint8List();
  return base64Encode(bytes);
}

class ImagePickerComponent extends StatelessWidget {
  const ImagePickerComponent({
    super.key,
    required this.cameraOnTap,
    required this.galleryOnTap,
  });
  final VoidCallback cameraOnTap;
  final VoidCallback galleryOnTap;

  static void show(
    BuildContext context, {
    required VoidCallback cameraOnTap,
    required VoidCallback galleryOnTap,
  }) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: cameraOnTap,
              child: const Text('Camera'),
            ),
            CupertinoActionSheetAction(
              onPressed: galleryOnTap,
              child: const Text('Gallery'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) => ImagePickerComponent(
          cameraOnTap: cameraOnTap,
          galleryOnTap: galleryOnTap,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOption(
                context,
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                color: Colors.blue,
                onTap: cameraOnTap,
              ),
              _buildOption(
                context,
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                color: Colors.purple,
                onTap: galleryOnTap,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
