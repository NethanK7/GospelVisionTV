import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// # 1-to-1 Netflix Navbar
class NetflixNavbar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final bool isDesktop;

  const NetflixNavbar({
    super.key,
    required this.scrollController,
    required this.isDesktop,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<NetflixNavbar> createState() => _NetflixNavbarState();
}

class _NetflixNavbarState extends State<NetflixNavbar> {
  double _backgroundOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(NetflixNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final offset = widget.scrollController.offset;
    final newOpacity = (offset / 100).clamp(0.0, 1.0);
    if (newOpacity != _backgroundOpacity) {
      setState(() {
        _backgroundOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current route to highlight the active tab
    final String currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      color: Colors.black.withOpacity(_backgroundOpacity),
      padding: EdgeInsets.symmetric(
        horizontal: widget.isDesktop
            ? 60
            : 20, // Netflix uses a lot of horizontal padding
      ).copyWith(top: MediaQuery.of(context).padding.top + 10, bottom: 15),
      child: Row(
        children: [
          // LOGO
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
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

          if (widget.isDesktop) ...[
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
          if (widget.isDesktop) ...[
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
              behavior: HitTestBehavior.opaque,
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

          if (widget.isDesktop) ...[
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
    // Exact match for 'Home' since other mock tabs also use '/home'
    final bool isActive = title == 'Home'
        ? currentPath == routePath
        : currentPath.startsWith(routePath);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!isActive) {
            context.go(routePath);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
}
