import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/refuel_dashboard_notifier.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/widgets/dashboard_content.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/widgets/loading_state_widget.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/widgets/error_state_widget.dart';

class RefuelDashboardScreen extends ConsumerWidget {
  const RefuelDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get actual user bike ID from user preferences or selection
    const userBikeId = 1;
    final dashboardAsync = ref.watch(refuelDashboardProvider(userBikeId));

    return CommonScaffold(
      title: 'FuelSense',
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_refuel');
        },
        tooltip: 'Add Refuel Entry',
        child: const Icon(Icons.add),
      ),
      body: dashboardAsync.when(
        data: (state) => const DashboardContent(userBikeId: userBikeId),
        loading: () => const LoadingStateWidget(),
        error: (error, stack) =>
            ErrorStateWidget(userBikeId: userBikeId, error: error),
      ),
    );
  }
}
