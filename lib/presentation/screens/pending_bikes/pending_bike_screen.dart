import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/presentation/screens/pending_bikes/pending_bikes_notifier.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'package:fuelsense/presentation/widgets/response_text.dart';
import 'package:fuelsense/presentation/widgets/search_bar_widget.dart';

import '../../widgets/bike/bike_card.dart';
import '../../widgets/bike/bike_details.dart';

class PendingBikeScreen extends ConsumerStatefulWidget {
  const PendingBikeScreen({super.key});

  @override
  ConsumerState<PendingBikeScreen> createState() => _PendingBikeScreenState();
}

class _PendingBikeScreenState extends ConsumerState<PendingBikeScreen> {
  String _searchQuery = "";
  final _searchController = TextEditingController();

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
      ref.read(pendingBikesNotifierProvider.notifier).syncPendingBikes();
    });
  }

  List<Bike> _filterBikes(List<Bike> bikes) {
    if (_searchQuery.isEmpty) return bikes;
    final query = _searchQuery.toLowerCase();
    return bikes.where((bike) {
      return bike.brand.toLowerCase().contains(query) ||
          bike.model.toLowerCase().contains(query) ||
          bike.modelYear.toString().contains(query) ||
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
    final state = ref.watch(pendingBikesNotifierProvider);
    final filteredBikes = _filterBikes(state.pendingBikes);
    return CommonScaffold(
      title: "Pending Bikes",
      body: Column(
        children: [
          SearchBarWidget(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            controller: _searchController,
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.message != null && !state.isSuccess
                ? Center(
                    child: ResponseText(
                      success: state.isSuccess,
                      message: state.message!,
                    ),
                  )
                : state.pendingBikes.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredBikes.length,
                    itemBuilder: (context, index) {
                      final bike = filteredBikes[index];
                      return BikeCard(
                        bike: bike,
                        trailingIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.hourglass_bottom_rounded),
                        ),
                        onTap: () {
                          bikeDetails(context, bike, [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                      ),
                                    ),
                                  ),
                                ),
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
                                          pendingBikesNotifierProvider.notifier,
                                        )
                                        .deleteBike(bike.id);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .read(
                                          pendingBikesNotifierProvider.notifier,
                                        )
                                        .approveBike(bike.id);
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.save_rounded),
                                ),
                              ],
                            ),
                          ]);
                        },
                      );
                    },
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("No Pending Bikes")],
                  ),
          ),
        ],
      ),
    );
  }
}
