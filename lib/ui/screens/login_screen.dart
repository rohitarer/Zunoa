import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/ui/screens/profile_screen.dart';
import 'package:zunoa/ui/screens/signup_screen.dart';
import 'package:zunoa/ui/widgets/custom_textformfield.dart';
import 'package:zunoa/ui/widgets/custom_button.dart';
import 'package:zunoa/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim());

      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Login', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Welcome Back 👋",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please enter your credentials to login",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextFormField(
                    controller: _emailController,
                    label: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val!.isEmpty ? "Email required" : null,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(height: 22),

                  CustomTextFormField(
                    controller: _passwordController,
                    label: "Password",
                    hintText: "Enter your password",
                    prefixIcon: Icons.lock,
                    isPassword: _obscurePassword,
                    suffixIcon:
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator:
                        (val) =>
                            val!.length < 6
                                ? "Password must be 6+ characters"
                                : null,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: authState.isLoading ? "Logging In..." : "Login",
                    onPressed: authState.isLoading ? null : _login,
                    backgroundColor: AppTheme.primaryColor,
                    textColor: Colors.white,
                    width: double.infinity,
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to Forgot Password screen
                      },
                      child: const Text("Forgot Password?"),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have an account? ",
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: "Create Account",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SignUpScreen(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
