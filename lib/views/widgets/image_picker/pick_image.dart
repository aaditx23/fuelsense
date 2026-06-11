import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuelsense/views/widgets/image_picker/pick_crop_image.dart';
import 'package:fuelsense/views/widgets/image_picker/view_image.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  final double size;
  final void Function(String?) onSet;
  final String defaultImage;
  final bool circle;
  const PickImage({
    super.key,
    this.size = 80,
    required this.onSet,
    required this.defaultImage,
    required this.circle,
  });

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  String? image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        image = await pickCropImage(ImageSource.gallery);
        widget.onSet(image);
        setState(() {});
      }, // Use the provided onClick callback
      child: Stack(
        alignment: Alignment.center,
        children: [
          ViewImage(
            circle: widget.circle,
            size: widget.size / 2,
            memory: image == null,
            image: (image == null) ? widget.defaultImage : image!,
          ),

          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.5 * 255).toInt()),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
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
