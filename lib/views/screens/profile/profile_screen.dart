import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/views/screens/profile/profile_notifier.dart';
import 'package:fuelsense/views/widgets/common_scaffold.dart';
import 'package:fuelsense/views/widgets/profile_image_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);

    return CommonScaffold(
      title: "Profile",
      showDrawer: true,
      body: Center(
      child: state.isLoading
          ? const CircularProgressIndicator()
          : state.message != null
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
                  imageUrl: state.user!.profile_image,
                  radius: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text('Name: ${state.user!.username}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Email: ${state.user!.email}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Role: ${state.user!.role}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    ),);
  }
}
