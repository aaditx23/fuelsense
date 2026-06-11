import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/data/models/auth/request.dart';
import 'package:fuelsense/presentation/screens/auth/login/login_notifier.dart';
import 'package:fuelsense/presentation/screens/auth/login/login_state.dart';
import 'package:fuelsense/presentation/widgets/password_field.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';
import 'package:fuelsense/presentation/widgets/response_text.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(loginNotifier.notifier).resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginState state = ref.watch(loginNotifier);

    ref.listen(loginNotifier, (prev, next) {
      if (next.isSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/profile");
          }
        });
      }
    });

    void onLogin() {
      if (_formKey.currentState!.validate()) {
        final loginRequest = LoginRequest(
          username: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        ref.read(loginNotifier.notifier).login(loginRequest);
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
                        'Welcome back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedTextField(
                        controller: _emailController,
                        labelText: 'Email/Username',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter Email/Username';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      PasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter password';
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: state.isLoading ? null : () => onLogin(),
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
                            : const Text('Login'),
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
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/signup");
                            },
                            child: const Text('Sign up'),
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
