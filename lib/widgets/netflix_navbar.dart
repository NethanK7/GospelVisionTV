import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

// Removed MagneticNavItem as desktop top routing is deprecated
/// # Glow-Logic Navbar
class NetflixNavbar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;

  const NetflixNavbar({super.key, required this.scrollController});

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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width >= 600 ? 56 : 16,
        MediaQuery.of(context).padding.top + 16,
        MediaQuery.of(context).size.width >= 600 ? 56 : 16,
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _backgroundOpacity > 0 ? 20.0 : 5.0,
            sigmaY: _backgroundOpacity > 0 ? 20.0 : 5.0,
          ),
          child: Stack(
            children: [
              Container(
                color: AppTheme.deepObsidian.withValues(
                  alpha: _backgroundOpacity > 0 ? 0.7 : 0.2,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LOGO (Leading on Mobile/Tablet)
                      _buildLogo(context),
                      // RIGHT SIDE ICONS
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
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return GestureDetector(
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
    );
  }

  Widget _buildRightSideIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Profile Avatar
        GestureDetector(
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
      ],
    );
  }
}
