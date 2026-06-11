import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/incomplete_entry_warning.dart';
import 'package:fuelsense/presentation/screens/create_refuel/tabs/reserve_hit_tab.dart';
import 'package:fuelsense/presentation/screens/create_refuel/tabs/refuel_tab.dart';
import 'package:fuelsense/presentation/screens/create_refuel/tabs/topup_tab.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/submit_button.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';

class CreateRefuelScreen extends ConsumerStatefulWidget {
  const CreateRefuelScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateRefuelScreen> createState() => _CreateRefuelScreenState();
}

class _CreateRefuelScreenState extends ConsumerState<CreateRefuelScreen>
    with SingleTickerProviderStateMixin {
  final _reserveHitFormKey = GlobalKey<FormState>();
  final _refuelFormKey = GlobalKey<FormState>();
  final _topupFormKey = GlobalKey<FormState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupTabControllerListener();

    // Check for incomplete entry on init
    Future.microtask(() {
      ref.read(createRefuelNotifierProvider.notifier).checkIncompleteEntry(1);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setupTabControllerListener() {
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final notifier = ref.read(createRefuelNotifierProvider.notifier);
        final state = ref.read(createRefuelNotifierProvider);

        if (!state.hasIncompleteEntry) {
          switch (_tabController.index) {
            case 0:
              notifier.updateRefuelType(CreateRefuelType.reserveHit);
              break;
            case 1:
              notifier.updateRefuelType(CreateRefuelType.refuel);
              break;
            case 2:
              notifier.updateRefuelType(CreateRefuelType.topup);
              break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);

    // Force tab to refuel (index 1) when incomplete entry exists
    if (state.hasIncompleteEntry && _tabController.index != 1) {
      _tabController.animateTo(1);
    }

    return CommonScaffold(
      title: state.hasIncompleteEntry ? 'Complete Refuel' : 'Add Refuel Entry',
      showDrawer: false,
      body: state.isLoading && state.incompleteEntry == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Incomplete entry warning
                if (state.hasIncompleteEntry) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: IncompleteEntryWarning(),
                  ),
                ],

                // TabBar for entry types - always show but disable when incomplete
                Material(
                  color: Theme.of(context).colorScheme.surface,
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.warning_rounded,
                          color: state.hasIncompleteEntry
                              ? Theme.of(context).disabledColor
                              : null,
                        ),
                        child: Text(
                          'Reserve Hit',
                          style: TextStyle(
                            color: state.hasIncompleteEntry
                                ? Theme.of(context).disabledColor
                                : null,
                          ),
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.local_gas_station_rounded,
                          color: state.hasIncompleteEntry
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        child: Text(
                          'Refuel',
                          style: TextStyle(
                            color: state.hasIncompleteEntry
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.add_rounded,
                          color: state.hasIncompleteEntry
                              ? Theme.of(context).disabledColor
                              : null,
                        ),
                        child: Text(
                          'Top-up',
                          style: TextStyle(
                            color: state.hasIncompleteEntry
                                ? Theme.of(context).disabledColor
                                : null,
                          ),
                        ),
                      ),
                    ],
                    onTap: state.hasIncompleteEntry
                        ? (index) {
                            // Only allow tapping on refuel tab when incomplete
                            if (index != 1) {
                              _tabController.animateTo(1);
                            }
                          }
                        : null,
                  ),
                ),

                // Form content - always show all tabs
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: state.hasIncompleteEntry
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    children: [
                      // Reserve Hit tab
                      _buildFormTab(
                        child: ReserveHitTab(
                          isIncomplete: state.hasIncompleteEntry,
                        ),
                        formKey: _reserveHitFormKey,
                      ),
                      // Refuel tab
                      _buildFormTab(
                        child: const RefuelTab(),
                        formKey: _refuelFormKey,
                      ),
                      // Top-up tab
                      _buildFormTab(
                        child: const TopupTab(),
                        formKey: _topupFormKey,
                      ),
                    ],
                  ),
                ),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SubmitButton(
                    onPressed: () async {
                      // Get the appropriate form key based on current state
                      final GlobalKey<FormState> currentFormKey;
                      if (state.hasIncompleteEntry) {
                        currentFormKey = _refuelFormKey;
                      } else {
                        switch (_tabController.index) {
                          case 0:
                            currentFormKey = _reserveHitFormKey;
                            break;
                          case 1:
                            currentFormKey = _refuelFormKey;
                            break;
                          case 2:
                            currentFormKey = _topupFormKey;
                            break;
                          default:
                            return; // Invalid tab
                        }
                      }

                      if (currentFormKey.currentState?.validate() ?? false) {
                        // TODO: Get actual user ID and bike ID
                        final success = await notifier.submitEntry(1, 1);
                        if (success && mounted) {
                          // Navigate back after successful submission
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (mounted) Navigator.of(context).pop();
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFormTab({
    required Widget child,
    required GlobalKey<FormState> formKey,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(key: formKey, child: child),
    );
  }
}
