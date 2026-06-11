import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/refuel_list/refuel_list_notifier.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'package:fuelsense/presentation/screens/refuel_list/widgets/empty_state_widget.dart';
import 'package:fuelsense/presentation/screens/refuel_list/widgets/refuel_list_content.dart';
import 'package:fuelsense/presentation/screens/refuel_list/widgets/list_error_state_widget.dart';

class RefuelListScreen extends ConsumerWidget {
  const RefuelListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get actual user bike ID
    const userBikeId = 1;
    final refuelsAsync = ref.watch(refuelListStreamProvider(userBikeId));

    return CommonScaffold(
      title: 'Refuel History',
      showDrawer: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.invalidate(refuelListStreamProvider(userBikeId));
          },
        ),
      ],
      body: refuelsAsync.when(
        data: (refuels) => refuels.isEmpty
            ? const EmptyStateWidget()
            : RefuelListContent(userBikeId: userBikeId, refuels: refuels),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            ListErrorStateWidget(userBikeId: userBikeId, error: error),
      ),
    );
  }
}
