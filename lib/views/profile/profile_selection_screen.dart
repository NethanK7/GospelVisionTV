import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_controller.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final profiles = controller.profiles;
    final isDesktop = MediaQuery.of(context).size.width >= 800;
    final profileSize = isDesktop ? 120.0 : 90.0;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: FadeTransition(
        opacity: _fadeController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                "Who's Watching?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 48 : 28,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: isDesktop ? 50 : 35),

              // Profiles Grid
              Wrap(
                spacing: isDesktop ? 30 : 20,
                runSpacing: isDesktop ? 30 : 20,
                alignment: WrapAlignment.center,
                children: [
                  ...List.generate(profiles.length, (index) {
                    return _buildProfileCard(
                      profiles[index],
                      index,
                      profileSize,
                    );
                  }),
                  // Add Profile button
                  _buildAddProfileButton(profileSize),
                ],
              ),

              SizedBox(height: isDesktop ? 50 : 35),

              // Manage Profiles
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  'Manage Profiles',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProfileModel profile, int index, double size) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          final controller = Provider.of<HomeController>(
            context,
            listen: false,
          );
          controller.setActiveProfile(profile);
          context.go('/subscription');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: profile.color.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: isHovered
                      ? Border.all(color: Colors.white, width: 2.5)
                      : null,
                ),
                child: Icon(
                  profile.icon,
                  size: size * 0.5,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                profile.name,
                style: TextStyle(
                  color: isHovered
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
              if (profile.isKids) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'KIDS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddProfileButton(double size) {
    final isHovered = _hoveredIndex == -1;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = -1),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: isHovered ? 1.0 : 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add,
                size: size * 0.4,
                color: Colors.white.withValues(alpha: isHovered ? 1.0 : 0.5),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add Profile',
              style: TextStyle(
                color: Colors.white.withValues(alpha: isHovered ? 1.0 : 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
