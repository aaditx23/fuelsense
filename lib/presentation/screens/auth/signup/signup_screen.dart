import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/data/dropdown_values/role_type.dart';
import 'package:fuelsense/data/models/auth/request.dart';
import 'package:fuelsense/presentation/screens/auth/signup/signup_notifier.dart';
import 'package:fuelsense/presentation/screens/auth/signup/signup_state.dart';
import 'package:fuelsense/presentation/widgets/dropdown_widget.dart';
import 'package:fuelsense/presentation/widgets/image_picker/pick_crop_image.dart';
import 'package:fuelsense/presentation/widgets/image_picker/pick_image.dart';
import 'package:fuelsense/presentation/widgets/password_field.dart';
import 'package:fuelsense/presentation/widgets/response_text.dart';
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

  String _selectedRole = "user";
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(signupNotifierProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _profileImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignupState state = ref.watch(signupNotifierProvider);

    ref.listen(signupNotifierProvider, (prev, next) {
      if (next.isSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/profile");
          }
        });
      }
    });

    void onSignup() {
      if (_formKey.currentState!.validate()) {
        final signupRequest = SignupRequest(
          username: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          profileImage: _profileImage?.trim(),
          role: _selectedRole,
        );
        ref.read(signupNotifierProvider.notifier).signup(signupRequest);
      }
    }

    return Scaffold(
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
                      PickImage(
                        onSet: (image) {
                          _profileImage = image;
                        },
                        defaultImage: "assets/images/user_default.png",
                        circle: true,
                      ),
                      const SizedBox(height: 12),
                      OutlinedTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      OutlinedTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your Email'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      PasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your password'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state.isLoading ? null : () => onSignup(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
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
                        ResponseText(
                          success: state.isSuccess,
                          message: state.message!,
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
