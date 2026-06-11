import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/widgets/refuel_metrics_header.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/widgets/recent_refuels_card.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/refuel_dashboard_notifier.dart';

class DashboardContent extends ConsumerWidget {
  final int userBikeId;

  const DashboardContent({Key? key, required this.userBikeId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(refuelStreamProvider(userBikeId));
        ref.invalidate(fuelMetricsProvider(userBikeId));
      },
      child: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: [RefuelMetricsHeader(), RecentRefuelsCard()]),
      ),
    );
  }
}
