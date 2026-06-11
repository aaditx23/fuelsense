import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/data/dropdown_values/role_type.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_notifier.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_state.dart';
import 'package:fuelsense/views/widgets/dropdown_widget.dart';
import 'package:fuelsense/views/widgets/image_picker/pick_crop_image.dart';
import 'package:fuelsense/views/widgets/image_picker/pick_image.dart';
import 'package:fuelsense/views/widgets/password_field.dart';
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
      ref.read(signupNotifier.notifier).reset();
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
      if (_formKey.currentState!.validate()) {
        final signupRequest = SignupRequest(
          username: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          profileImage: _profileImage?.trim(),
          role: _selectedRole,
        );
        print("ISGNUP REQUEST: ${signupRequest.profileImage}");
        ref.read(signupNotifier.notifier).signup(signupRequest);
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
                        circle: false,
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

                      DropdownWidget(
                        items: roleType,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value ?? "user";
                          });
                        },
                        labelText: "Role",
                        prefixIcon: Icons.add_moderator_outlined,
                      ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            state.message!,
                            style: TextStyle(
                              color: state.isSuccess
                                  ? Colors.lightGreen
                                  : Colors.red,
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
