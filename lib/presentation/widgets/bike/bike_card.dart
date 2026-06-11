import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';

class BikeCard extends StatelessWidget {
  final Bike bike;
  final Function onTap;
  final Widget? trailingIcon;

  const BikeCard({
    super.key,
    required this.bike,
    required this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(36.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28.0,
                  backgroundImage:
                      (bike.image != null && bike.image!.isNotEmpty)
                      ? MemoryImage(base64Decode(bike.image!))
                      : AssetImage("assets/images/default_bike.png"),
                ),

                const SizedBox(width: 12),
                // Bike details
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${bike.brand} ${bike.model} ${bike.modelYear}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        "${bike.engineCc} CC",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailingIcon != null) trailingIcon!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
