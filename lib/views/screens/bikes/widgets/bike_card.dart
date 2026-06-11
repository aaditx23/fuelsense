import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';
import 'package:fuelsense/views/screens/bikes/widgets/bike_details.dart';

class BikeCard extends StatelessWidget {
  final BikeModel bike;
  final bool inMyBikes;
  final Function onAction;

  const BikeCard({
    super.key,
    required this.bike,
    required this.inMyBikes,
    required this.onAction
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
        ),
        color: Theme.of(context).colorScheme.tertiaryContainer,
        elevation: 0,
        child: InkWell(
          onTap: (){
            bikeDetails(context, bike, inMyBikes, onAction);
          },
          borderRadius: BorderRadius.circular(36.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28.0,
                  backgroundImage: (bike.image != null && bike.image!.isNotEmpty)
                      ? MemoryImage(base64Decode(bike.image!))
                      : AssetImage("assets/images/default_bike.png") ,
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),

                const SizedBox(width: 12),
                // Bike details
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${bike.brand} ${bike.model} ${bike.modelYear}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0
                      ),
                      maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text("${bike.engineCc} CC",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0
                      ),)

                    ],
                  ),
                ),
                IconButton(onPressed: (){
                  onAction();
                }, icon: Icon(inMyBikes? Icons.remove : Icons.add))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

