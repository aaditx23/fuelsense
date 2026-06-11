import 'dart:convert';

import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final bool circle;
  final double size;
  final bool isAsset;
  final String image;
  const ViewImage({
    super.key,
    required this.circle,
    required this.size,
    required this.isAsset,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.grey.withAlpha((0.5 * 255).toInt());
    final imageProvider = isAsset
        ? AssetImage(image)
        : MemoryImage(base64Decode(image));
    return Padding(
      padding: EdgeInsetsGeometry.all(6),
      child: circle
          ? CircleAvatar(
              radius: size,
              backgroundImage: imageProvider as ImageProvider,
              backgroundColor: bgColor,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Container(
                padding: EdgeInsets.all(12),
                color: bgColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image(
                    image: imageProvider as ImageProvider,
                    width: size,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
    );
  }
}
