import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';

class BikeCard extends StatelessWidget {
  final BikeModel bike;

  const BikeCard({
    super.key,
    required this.bike,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: bike.image != null && bike.image!.isNotEmpty
                  ? Image.memory(
                base64Decode(bike.image!),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(
                    Icons.motorcycle, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            // Bike details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${bike.brand} ${bike.model}', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium),
                  const SizedBox(height: 4),
                  Text('Engine: ${bike.engineCc} cc', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  Text('Year: ${bike.modelYear}', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  Text('Fuel: ${bike.fuelType}', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  Text('Mileage: ${bike.expectedMileage.toStringAsFixed(
                      1)} km/l', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  Text('Tank: ${bike.tankCapacity.toStringAsFixed(1)} L',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium),
                  if (bike.reserveCapacity != null)
                    Text('Reserve: ${bike.reserveCapacity!.toStringAsFixed(
                        1)} L', style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium),
                  const SizedBox(height: 8),
                  Text('Updated: ${bike.updatedAt}', style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

