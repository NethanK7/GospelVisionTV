import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// # 1-to-1 Netflix Navbar
class NetflixNavbar extends StatelessWidget implements PreferredSizeWidget {
  final double scrollOffset;
  final bool isDesktop;

  const NetflixNavbar({
    super.key,
    required this.scrollOffset,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    // Opacity based on scroll distance. Reaches 1.0 around 100px down.
    final double backgroundOpacity = (scrollOffset / 100).clamp(0.0, 1.0);
    // Get current route to highlight the active tab
    final String currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      color: Colors.black.withOpacity(backgroundOpacity),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? 60
            : 20, // Netflix uses a lot of horizontal padding
      ).copyWith(top: MediaQuery.of(context).padding.top + 10, bottom: 15),
      child: Row(
        children: [
          // LOGO
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/home'),
              child: const Text(
                'GOSPELVISION',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          if (isDesktop) ...[
            const SizedBox(width: 40),
            _buildDesktopNavLink(context, 'Home', '/home', currentRoute),
            _buildDesktopNavLink(
              context,
              'TV Shows',
              '/home',
              currentRoute,
            ), // Mock
            _buildDesktopNavLink(
              context,
              'Movies',
              '/home',
              currentRoute,
            ), // Mock
            _buildDesktopNavLink(
              context,
              'New & Popular',
              '/news',
              currentRoute,
            ),
            _buildDesktopNavLink(context, 'Live TV', '/livetv', currentRoute),
            _buildDesktopNavLink(
              context,
              'Settings',
              '/settings',
              currentRoute,
            ),
          ],

          const Spacer(),

          // RIGHT SIDE ICONS
          if (isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.search, size: 26),
              color: Colors.white,
              onPressed: () {},
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Kids',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 26),
              color: Colors.white,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
          ],

          // Profile Avatar
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/settings'),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(4),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          if (isDesktop) ...[
            const SizedBox(width: 10),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopNavLink(
    BuildContext context,
    String title,
    String routePath,
    String currentPath,
  ) {
    final bool isActive = currentPath.startsWith(routePath);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (!isActive) {
              context.go(routePath);
            }
          },
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
