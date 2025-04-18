import 'package:flutter/material.dart';
import 'package:zunoa/core/theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double iconSize;
  final double elevation;
  final bool showLabels;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.iconSize = 24.0,
    this.elevation = 8.0,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      backgroundColor:
          backgroundColor ??
          Theme.of(context).bottomAppBarTheme.color ??
          Theme.of(context).colorScheme.surface,
      selectedItemColor: selectedItemColor ?? AppTheme.primaryColor,
      unselectedItemColor: unselectedItemColor ?? Colors.grey,
      iconSize: iconSize,
      elevation: elevation,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      type: BottomNavigationBarType.fixed,
    );
  }
}
