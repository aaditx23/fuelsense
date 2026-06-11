import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/presentation/widgets/bike/bike_card.dart';
import 'package:fuelsense/presentation/widgets/bike/bike_details.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'package:fuelsense/presentation/widgets/search_bar_widget.dart';

import 'bike_notifier.dart';

class BikesScreen extends ConsumerStatefulWidget {
  const BikesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BikesScreen> createState() => _BikesScreenState();
}

class _BikesScreenState extends ConsumerState<BikesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBikes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBikes();
  }

  void _loadBikes() {
    Future.microtask(() {
      ref.read(bikeNotifierProvider.notifier).syncBikes();
    });
  }

  List<Bike> _filterBikes(List<Bike> bikes) {
    if (_searchQuery.isEmpty) return bikes;
    final query = _searchQuery.toLowerCase();
    return bikes.where((bike) {
      return bike.brand.toLowerCase().contains(query) ||
          bike.model.toLowerCase().contains(query) ||
          bike.modelYear.toString().contains(query) ||
          "${bike.brand} ${bike.model} ${bike.modelYear}"
              .toLowerCase()
              .contains(query) ||
          bike.engineCc.toString().contains(query) ||
          bike.fuelType.toLowerCase().contains(query) ||
          bike.expectedMileage.toString().contains(query) ||
          bike.tankCapacity.toString().contains(query) ||
          (bike.reserveCapacity?.toString().contains(query) ?? false) ||
          (bike.image?.toLowerCase().contains(query) ?? false) ||
          bike.updatedAt.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notifierState = ref.watch(bikeNotifierProvider);
    // Stream-based watch — auto-rebuilds whenever local DB changes
    final bikesAsync = ref.watch(allBikesStreamProvider);
    final filteredBikes = _filterBikes(bikesAsync.asData?.value ?? []);

    return CommonScaffold(
      showDrawer: true,
      title: "Bikes",
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          Expanded(
            child:
                notifierState.isLoading &&
                    (bikesAsync.asData?.value ?? []).isEmpty
                ? const Center(child: CircularProgressIndicator())
                : bikesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (_) => filteredBikes.isEmpty
                        ? const Center(child: Text('No bikes found'))
                        : ListView.builder(
                            itemCount: filteredBikes.length,
                            itemBuilder: (context, index) {
                              final bike = filteredBikes[index];
                              print("BIKE: ${bike.model} ${bike.isMine}");
                              return BikeCard(
                                bike: bike,
                                trailingIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    bike.isMine
                                        ? Icons.done_outline_rounded
                                        : Icons.remove_red_eye,
                                  ),
                                ),
                                onTap: () {
                                  bikeDetails(context, bike, [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.arrow_back_ios),
                                            ),
                                          ),
                                        ),
                                        if (ref
                                            .read(bikeNotifierProvider.notifier)
                                            .isAdmin()) ...[
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushNamed(
                                                context,
                                                "/edit_bike",
                                                arguments: bike,
                                              );
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              ref
                                                  .read(
                                                    bikeNotifierProvider
                                                        .notifier,
                                                  )
                                                  .deleteBike(bike.id);
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                        ],
                                        IconButton(
                                          onPressed: () {
                                            bike.isMine
                                                ? ref
                                                      .read(
                                                        bikeNotifierProvider
                                                            .notifier,
                                                      )
                                                      .removeBike(bike.id)
                                                : ref
                                                      .read(
                                                        bikeNotifierProvider
                                                            .notifier,
                                                      )
                                                      .selectBike(bike.id);
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(
                                            bike.isMine
                                                ? Icons.remove_circle
                                                : Icons.add_circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]);
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
