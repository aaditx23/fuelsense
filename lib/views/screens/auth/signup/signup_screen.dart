import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_notifier.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_state.dart';
import 'package:fuelsense/views/widgets/image_picker/pick_crop_image.dart';
import 'package:fuelsense/views/widgets/image_picker/pick_profile_image.dart';
import 'package:fuelsense/views/widgets/password_field.dart';
import 'package:fuelsense/views/widgets/role_dropdown.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/outlined_text_field.dart';


class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _profileImageController = TextEditingController();

  String _selectedRole = "user";
  String? _profileImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _profileImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignupState state = ref.watch(signupNotifier);

    ref.listen(signupNotifier, (prev, next) {
      if (next.isSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/profile");
          }
        });
      }
    });

    void onSignup() {
      final signupRequest = SignupRequest(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        profileImage: _profileImageController.text.trim().isEmpty ? null : _profileImageController.text.trim(),
        role: _selectedRole,
      );
      ref.read(signupNotifier.notifier).signup(signupRequest);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const FlutterLogo(size: 72),
                      const SizedBox(height: 16),
                      const Text(
                        'Create your account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PickProfileImage(
                        onClick: () async {
                          _profileImage = await pickCropImage(ImageSource.gallery);
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 12),
                      OutlinedTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || value.isEmpty ? 'Enter your Email' : null,
                      ),
                      const SizedBox(height: 12),
                      PasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                        validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
                      ),
                      const SizedBox(height: 12),
                      OutlinedTextField(
                        controller: _profileImageController,
                        labelText: 'Profile Image (optional)',
                      ),
                      const SizedBox(height: 12),
                      RoleDropdown(
                        value: _selectedRole,
                        onChanged: (val) {
                          setState(() {
                            _selectedRole = val ?? "user";
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  onSignup();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Signup'),
                      ),
                      const SizedBox(height: 12),
                      if (state.message != null && !state.isLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            state.message!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
