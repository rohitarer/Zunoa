import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zunoa/providers/auth_provider.dart';
import 'package:zunoa/services/firebase_service.dart';
import 'package:zunoa/ui/screens/profile_screen.dart';
import 'package:zunoa/ui/screens/splash_screen.dart';
import 'package:zunoa/ui/screens/signup_screen.dart';
import 'package:zunoa/ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  Future<Widget> _buildInitialScreen() async {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (user != null) {
      try {
        final userData = await firebaseService.fetchUserData(user.uid);
        final isProfileComplete = userData['isProfileComplete'] == true;
        return isProfileComplete ? const HomeScreen() : const ProfileScreen();
      } catch (e) {
        // fallback if user doc is missing or any error occurs
        return const ProfileScreen();
      }
    } else {
      return const SignUpScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Zunoa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home:
          _showSplash || !authState.isInitialized
              ? const SplashScreen()
              : FutureBuilder<Widget>(
                future: _buildInitialScreen(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasData) {
                    return snapshot.data!;
                  } else {
                    return const SignUpScreen(); // fallback
                  }
                },
              ),
    );
  }
}
