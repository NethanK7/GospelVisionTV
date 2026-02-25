import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.10),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
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
                  icon: Icons.live_tv_outlined,
                  activeIcon: Icons.live_tv,
                  label: 'Live TV',
                  isSelected: currentIndex == 1,
                  onTap: onTap,
                ),
                _NavItem(
                  index: 2,
                  icon: Icons.movie_outlined,
                  activeIcon: Icons.movie,
                  label: 'Movies',
                  isSelected: currentIndex == 2,
                  onTap: onTap,
                ),
                _NavItem(
                  index: 3,
                  icon: Icons.article_outlined,
                  activeIcon: Icons.article,
                  label: 'News',
                  isSelected: currentIndex == 3,
                  onTap: onTap,
                ),
                _NavItem(
                  index: 4,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Account',
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
      onTap: () {
        HapticFeedback.lightImpact();
        onTap(index);
      },
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
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, size: 14, color: Colors.white),
              )
            else
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? AppTheme.primaryOrange
                    : Colors.white.withValues(alpha: 0.45),
                size: 22,
                shadows: isSelected
                    ? [
                        Shadow(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.8),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
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
