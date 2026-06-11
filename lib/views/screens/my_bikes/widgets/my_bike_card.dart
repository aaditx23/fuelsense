import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';

class MyBikeCard extends StatelessWidget {
  final BikeModel bike;
  final Function onAction;

  const MyBikeCard({
    super.key,
    required this.bike,
    required this.onAction
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(36.0),
              child: (bike.image != null)
                  ? Image.memory(base64Decode(bike.image!))
                  : Image.asset("assets/images/default_bike.png"),
            ),
            SizedBox(height: 12,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Brand: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: bike.brand,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(text: '  '),
                  TextSpan(
                    text: 'Model: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: bike.model,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Engine: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${bike.engineCc} cc',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Year: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${bike.modelYear}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Fuel: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: bike.fuelType,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Mileage: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${bike.expectedMileage.toStringAsFixed(1)} km/l',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Tank: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${bike.tankCapacity.toStringAsFixed(1)} L',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (bike.reserveCapacity != null)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Reserve: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${bike.reserveCapacity!.toStringAsFixed(1)} L',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Updated: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  TextSpan(
                    text: bike.updatedAt,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: FilledButton(onPressed: () => onAction(), child: Text("Remove")))
          ],
        ),
      ),
    );
  }
}

