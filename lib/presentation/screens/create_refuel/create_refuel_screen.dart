import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/entry_type_card.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_amount_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_price_per_liter_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_total_cost_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/odometer_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/submit_button.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/trip_meter_field.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';

class CreateRefuelScreen extends ConsumerStatefulWidget {
  const CreateRefuelScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateRefuelScreen> createState() => _CreateRefuelScreenState();
}

class _CreateRefuelScreenState extends ConsumerState<CreateRefuelScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(createRefuelNotifierProvider.notifier).checkIncompleteEntry(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final isFirstEntryAsync = ref.watch(isFirstRefuelEntryProvider(1));
    final isFirstEntry = isFirstEntryAsync.value ?? false;

    final isFuelEntry =
        state.refuelType == CreateRefuelType.refuel ||
        state.refuelType == CreateRefuelType.topup;

    return CommonScaffold(
      title: state.hasIncompleteEntry ? 'Complete Refuel' : 'Add Refuel Entry',
      showDrawer: false,
      body: state.isLoading && state.incompleteEntry == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Entry type selection ──────────────────────────────
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        EntryTypeCard(
                          label: 'Reserve',
                          icon: Icons.warning_amber_rounded,
                          color: colorScheme.error,
                          selected:
                              state.refuelType == CreateRefuelType.reserveHit,
                          disabled: state.hasIncompleteEntry,
                          onTap: () => notifier.updateRefuelType(
                            CreateRefuelType.reserveHit,
                          ),
                        ),
                        const SizedBox(width: 8),
                        EntryTypeCard(
                          label: 'Refuel',
                          icon: Icons.local_gas_station_rounded,
                          color: colorScheme.primary,
                          selected: state.refuelType == CreateRefuelType.refuel,
                          disabled: state.hasIncompleteEntry,
                          onTap: () => notifier.updateRefuelType(
                            CreateRefuelType.refuel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        EntryTypeCard(
                          label: 'Top-up',
                          icon: Icons.add_circle_outline_rounded,
                          color: colorScheme.tertiary,
                          selected: state.refuelType == CreateRefuelType.topup,
                          disabled: state.hasIncompleteEntry,
                          onTap: () =>
                              notifier.updateRefuelType(CreateRefuelType.topup),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Meter Readings card ───────────────────────────────
                    _SectionCard(
                      icon: Icons.speed_rounded,
                      title: 'Meter Readings',
                      child: Column(
                        children: [
                          // info hint
                          _InfoBanner(
                            text: state.hasIncompleteEntry
                                ? 'Readings from your reserve hit entry'
                                : isFirstEntry
                                ? 'First entry: both readings are required'
                                : 'Enter at least one reading',
                            isHighlighted:
                                isFirstEntry && !state.hasIncompleteEntry,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 2,
                                child: TripMeterField(
                                  enabled: !state.hasIncompleteEntry,
                                  isFirstEntry: isFirstEntry,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                flex: 3,
                                child: OdometerField(
                                  enabled: !state.hasIncompleteEntry,
                                  isFirstEntry: isFirstEntry,
                                  userBikeId: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Fuel Details card (hidden for Reserve Hit) ────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SizeTransition(
                          sizeFactor: anim,
                          axisAlignment: -1,
                          child: child,
                        ),
                      ),
                      child: isFuelEntry
                          ? _SectionCard(
                              key: const ValueKey('fuel-details'),
                              icon: Icons.local_gas_station_rounded,
                              title: 'Fuel Details',
                              child: Column(
                                children: [
                                  const FuelPricePerLiterField(),
                                  const SizedBox(height: 12),
                                  _InfoBanner(
                                    text:
                                        'Enter either fuel amount or total cost — the other calculates automatically.',
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Expanded(child: FuelAmountField()),
                                      SizedBox(width: 12),
                                      Expanded(child: FuelTotalCostField()),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('no-fuel')),
                    ),

                    const SizedBox(height: 24),

                    // ── Submit ────────────────────────────────────────────
                    SubmitButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final success = await notifier.submitEntry(1, 1);
                          if (success && mounted) {
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                if (mounted) Navigator.of(context).pop();
                              },
                            );
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}

// ── Reusable section card ─────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Info banner ───────────────────────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  final String text;
  final bool isHighlighted;

  const _InfoBanner({required this.text, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isHighlighted
            ? colorScheme.primaryContainer.withValues(alpha: 0.4)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: isHighlighted
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isHighlighted
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
