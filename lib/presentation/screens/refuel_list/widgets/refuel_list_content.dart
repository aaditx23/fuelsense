import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/presentation/screens/refuel_list/refuel_list_notifier.dart';
import 'package:fuelsense/presentation/screens/refuel_list/widgets/refuel_card.dart';

class RefuelListContent extends ConsumerWidget {
  final int userBikeId;
  final List<Refuel> refuels;

  const RefuelListContent({
    Key? key,
    required this.userBikeId,
    required this.refuels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(refuelListStreamProvider(userBikeId));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: refuels.length,
        itemBuilder: (context, index) {
          return RefuelCard(refuel: refuels[index]);
        },
      ),
    );
  }
}
