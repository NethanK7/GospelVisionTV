import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// Magnetic Hover Nav Item
class MagneticNavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const MagneticNavItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<MagneticNavItem> createState() => _MagneticNavItemState();
}

class _MagneticNavItemState extends State<MagneticNavItem> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _mousePosition = Offset.zero;
      }),
      onHover: (event) {
        // Calculate movement based on distance from center (approximate bounding box height 40, width 80)
        setState(() {
          _mousePosition = event.localPosition;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            _isHovered ? ((_mousePosition.dx - 40) * 0.15) : 0,
            _isHovered ? ((_mousePosition.dy - 20) * 0.15) : 0,
            0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              fontWeight: widget.isActive ? FontWeight.w800 : FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.5,
              shadows: widget.isActive
                  ? [
                      Shadow(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}

/// # Glow-Logic Navbar
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
    final String currentRoute = GoRouterState.of(context).uri.path;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _backgroundOpacity > 0 ? 15.0 : 0.0,
          sigmaY: _backgroundOpacity > 0 ? 15.0 : 0.0,
        ),
        child: Stack(
          children: [
            Container(
              color: AppTheme.deepObsidian.withValues(
                alpha: _backgroundOpacity * 0.8,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isDesktop ? 60 : 20,
              ).copyWith(top: MediaQuery.of(context).padding.top, bottom: 0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LEFT SIDE (Links on Desktop, None on Mobile)
                    if (widget.isDesktop)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MagneticNavItem(
                              label: 'Home',
                              isActive: currentRoute.startsWith('/home'),
                              onTap: () => context.go('/home'),
                            ),
                            MagneticNavItem(
                              label: 'Live TV',
                              isActive: currentRoute.startsWith('/livetv'),
                              onTap: () => context.go('/livetv'),
                            ),
                            MagneticNavItem(
                              label: 'Movies',
                              isActive: currentRoute.startsWith('/movies'),
                              onTap: () => context.go('/movies'),
                            ),
                            MagneticNavItem(
                              label: 'News',
                              isActive: currentRoute.startsWith('/news'),
                              onTap: () => context.go('/news'),
                            ),
                          ],
                        ),
                      ),

                    // LOGO (Center on Desktop, Leading on Mobile)
                    widget.isDesktop
                        ? Center(child: _buildLogo(context))
                        : _buildLogo(context),

                    if (!widget.isDesktop) const Spacer(),

                    // RIGHT SIDE ICONS
                    if (widget.isDesktop)
                      Expanded(child: _buildRightSideIcons(context))
                    else
                      _buildRightSideIcons(context),
                  ],
                ),
              ),
            ),

            // 1px Border Gold gradient that fades in
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 1,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _backgroundOpacity > 0 ? 1.0 : 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.brandGradient,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('/home'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            'assets/images/gv_logo.png',
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildRightSideIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
    );
  }
}
