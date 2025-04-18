import 'package:flutter/material.dart';
import 'package:zunoa/ui/screens/splash_screen.dart';
import 'package:zunoa/ui/screens/signup_screen.dart';
import 'package:zunoa/ui/screens/login_screen.dart';
import 'package:zunoa/ui/screens/base_screen.dart';
import 'package:zunoa/ui/screens/profile_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const BaseScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('404 • Page Not Found')),
              ),
        );
    }
  }
}
