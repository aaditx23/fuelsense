import 'dart:convert';
import 'dart:io';

import 'package:fuelsense/presentation/widgets/image_picker/request_permission.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> pickCropImage(ImageSource source) async {
  await requestPermissions();
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: source);
  if (pickedImage == null) return null;

  final cropped = await ImageCropper().cropImage(
    sourcePath: pickedImage.path,
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 80, // Lower quality for smaller size
    maxWidth: 512, // Limit width
    maxHeight: 512, // Limit height
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: "Crop Image",
        initAspectRatio: CropAspectRatioPreset.square,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.original,
        ],
      ),
      IOSUiSettings(
        title: "Crop Image",
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.original,
        ],
      ),
    ],
  );

  if (cropped == null) return null;

  final bytes = await File(cropped.path).readAsBytes();
  final base64String = base64Encode(bytes);

  return base64String;
}
