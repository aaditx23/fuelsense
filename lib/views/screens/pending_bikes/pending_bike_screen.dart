import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';
import 'package:fuelsense/views/screens/pending_bikes/pending_bikes_notifier.dart';
import 'package:fuelsense/views/screens/pending_bikes/widgets/pending_bike_card.dart';
import 'package:fuelsense/views/widgets/common_scaffold.dart';
import 'package:fuelsense/views/widgets/response_text.dart';
import 'package:fuelsense/views/widgets/search_bar_widget.dart';

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
    Future.microtask(
      () => ref.read(pendingBikesNotifierProvider.notifier).pendingBikes(),
    );
  }

  List<BikeModel> _filterBikes(List<BikeModel> bikes) {
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
    final _filteredBikes = _filterBikes(state.pendingBikes);
    return CommonScaffold(
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
                    itemCount: _filteredBikes.length,
                    itemBuilder: (context, index) {
                      final bike = _filteredBikes[index];
                      return PendingBikeCard(bike: bike, onAdd: () {});
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
