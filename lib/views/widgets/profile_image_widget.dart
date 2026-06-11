import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String defaultAsset;

  const ProfileImageWidget({
    Key? key,
    required this.imageUrl,
    this.radius = 40,
    this.defaultAsset = 'assets/images/user_default.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(defaultAsset),
      );
    }
  }
}

