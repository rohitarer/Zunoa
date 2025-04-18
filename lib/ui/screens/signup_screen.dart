import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/ui/screens/login_screen.dart';
import 'package:zunoa/ui/widgets/custom_button.dart';
import 'package:zunoa/ui/widgets/custom_textformfield.dart';
import 'package:zunoa/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(), // ✅ pass name here
          );

      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.black87),
        ),
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
                    "Welcome to Zunoa 👋",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Let’s create your account to get started",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextFormField(
                    controller: _nameController,
                    label: "Full Name",
                    hintText: "Enter your name",
                    prefixIcon: Icons.person,
                    validator: (val) => val!.isEmpty ? "Name required" : null,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(height: 22),

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
                  const SizedBox(height: 22),

                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    hintText: "Re-enter your password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: _obscureConfirmPassword,
                    suffixIcon:
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator:
                        (val) =>
                            val != _passwordController.text
                                ? "Passwords do not match"
                                : null,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: authState.isLoading ? "Signing Up..." : "Sign Up",
                    onPressed: authState.isLoading ? null : _signUp,
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

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: "Login",
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
                                            (context) => const LoginScreen(),
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
