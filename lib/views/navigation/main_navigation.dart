import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class MainNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width >= 800;

    // For Desktop/Web, we let the individual screens handle their own NetflixNavbar
    if (isWideScreen) {
      return Scaffold(backgroundColor: Colors.black, body: navigationShell);
    }

    // For Mobile, we use the floating glassmorphic bottom navigation bar
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: navigationShell,
      bottomNavigationBar: _MobileBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
      ),
    );
  }
}

class _MobileBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MobileBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_filled,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: onTap,
                ),
                _NavItem(
                  index: 1,
                  icon: Icons.search,
                  activeIcon: Icons.search,
                  label: 'Search',
                  isSelected: currentIndex == 1,
                  onTap: onTap,
                ),
                _NavItem(
                  index: 2,
                  icon: Icons.play_circle_outline,
                  activeIcon: Icons.play_circle_filled,
                  label: 'New & Hot',
                  isSelected: currentIndex == 2,
                  onTap: onTap,
                ),
                _NavItem(
                  index: 3,
                  icon: Icons.live_tv_outlined,
                  activeIcon: Icons.live_tv,
                  label: 'Live TV',
                  isSelected: currentIndex == 3,
                  onTap: onTap,
                ),
                _NavItem(
                  index: 4,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'My GV',
                  isSelected: currentIndex == 4,
                  onTap: onTap,
                  isProfile: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final ValueChanged<int> onTap;
  final bool isProfile;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 16 : 0,
              height: 2.5,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Icon
            if (isProfile && isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryOrange, Color(0xFFE85D04)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(Icons.person, size: 14, color: Colors.white),
              )
            else
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.45),
                size: 22,
              ),
            const SizedBox(height: 3),
            // Label
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
