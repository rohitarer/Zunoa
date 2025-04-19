import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/providers/auth_provider.dart';
import 'package:zunoa/ui/screens/anonymous_chat_screen.dart';
import 'package:zunoa/ui/screens/bot_screen.dart';
import 'package:zunoa/ui/screens/connect_screen.dart';
import 'package:zunoa/ui/screens/explore_screen.dart';
import 'package:zunoa/ui/widgets/custom_bottom_nav_bar.dart';

class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key});

  @override
  ConsumerState<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ExploreScreen(),
    BotScreen(),
    const AnonymousChatScreen(),
    const ConnectScreen(),
    const DashboardScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline),
      label: 'Bot',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.privacy_tip_outlined),
      label: 'Anon',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Connect'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        iconSize: 26,
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Your Profile & Progress"));
  }
}
