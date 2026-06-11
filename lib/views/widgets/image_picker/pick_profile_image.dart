import 'package:flutter/material.dart';

class PickProfileImage extends StatefulWidget {
  final double size;
  final VoidCallback? onClick;
  final String? image;
  const PickProfileImage({Key? key, this.size = 80, this.onClick, this.image}) : super(key: key);

  @override
  State<PickProfileImage> createState() => _PickProfileImageState();
}

class _PickProfileImageState extends State<PickProfileImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick, // Use the provided onClick callback
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.size / 2,
            backgroundColor: Colors.grey.withAlpha((0.2 * 255).toInt()),
            backgroundImage: AssetImage( widget.image ?? "assets/images/user_default.png"),

          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
