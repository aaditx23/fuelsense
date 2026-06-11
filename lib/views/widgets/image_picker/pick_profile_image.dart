import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuelsense/views/widgets/image_picker/pick_crop_image.dart';
import 'package:image_picker/image_picker.dart';

class PickProfileImage extends StatefulWidget {
  final double size;
  final void Function(String?) onSet;
  const PickProfileImage({Key? key, this.size = 80, required this.onSet}) : super(key: key);

  @override
  State<PickProfileImage> createState() => _PickProfileImageState();
}

class _PickProfileImageState extends State<PickProfileImage> {
  String? image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        image = await pickCropImage(ImageSource.gallery);
        widget.onSet(image);
        print(image);
        setState(() {

        });
      }, // Use the provided onClick callback
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.size / 2,
            backgroundColor: Colors.grey.withAlpha((0.5 * 255).toInt()),
            backgroundImage: (image != null)
                ? MemoryImage(base64Decode(image!))
                : const AssetImage('assets/images/user_default.png') as ImageProvider,

          ),
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.5 * 255).toInt()),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.upload,
                size: widget.size * 0.22,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
