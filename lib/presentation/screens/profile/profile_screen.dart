import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/profile/profile_notifier.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'package:fuelsense/presentation/widgets/profile_image_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Sync is now handled automatically in the provider
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(profileNotifierProvider);

    return CommonScaffold(
      title: "Profile",
      showDrawer: true,
      body: Center(
        child: asyncState.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) =>
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
          data: (state) => state.message != null
              ? Text(state.message!, style: const TextStyle(color: Colors.red))
              : state.user == null
              ? const Text('No user data')
              : Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: ProfileImageWidget(
                            imageUrl: state.user!.profileImage,
                            radius: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Name: ${state.user!.username}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: ${state.user!.email}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Role: ${state.user!.role}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${state.user!.id}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/refuel_dashboard');
                          },
                          icon: const Icon(Icons.local_gas_station),
                          label: const Text('Fuel Tracking'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
