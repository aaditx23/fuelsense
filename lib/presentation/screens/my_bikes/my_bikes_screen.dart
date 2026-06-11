import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/presentation/screens/my_bikes/widgets/my_bike_card.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'package:fuelsense/presentation/widgets/response_text.dart';
import 'package:fuelsense/presentation/widgets/search_bar_widget.dart';
import 'my_bikes_notifier.dart';

class MyBikesScreen extends ConsumerStatefulWidget {
  const MyBikesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyBikesScreen> createState() => _BikesScreenState();
}

class _BikesScreenState extends ConsumerState<MyBikesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(myBikesNotifierProvider.notifier).syncMyBikes(),
    );
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
    final state = ref.watch(myBikesNotifierProvider);
    final filteredBikes = _filterBikes(state.myBikes);
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
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.message != null && !state.isSuccess
                ? Center(
                    child: ResponseText(
                      success: state.isSuccess,
                      message: state.message!,
                    ),
                  )
                : state.myBikes.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredBikes.length,
                    itemBuilder: (context, index) {
                      final bike = filteredBikes[index];
                      print("MY BIKE ${bike.isMine}");
                      return MyBikeCard(
                        bike: bike,
                        onAction: () {
                          ref
                              .read(myBikesNotifierProvider.notifier)
                              .removeBike(bike.id);
                        },
                      );
                    },
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/bikes");
                        },
                        child: Text("Click Here to browse and add bikes"),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
