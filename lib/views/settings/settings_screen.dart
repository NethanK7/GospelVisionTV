import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/home_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/netflix_navbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final controller = Provider.of<HomeController>(context);
    final profile = controller.profiles.isNotEmpty
        ? controller.profiles.first
        : null;

    return Scaffold(
      backgroundColor: AppTheme.deepObsidian,
      extendBodyBehindAppBar: true,
      appBar: NetflixNavbar(scrollController: _scrollController),
      body: Container(
        decoration: AppTheme.radialBackground,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 60 : 16),
            child:
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(context).padding.top +
                              (isTablet ? 100 : 80),
                        ),
                        // Header
                        Row(
                          children: [
                            const Text(
                              'My Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.cast_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Profile card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF1E1E1E),
                                const Color(0xFF2A1A0E).withValues(alpha: 0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      profile?.color ?? AppTheme.primaryOrange,
                                      (profile?.color ?? AppTheme.primaryOrange)
                                          .withValues(alpha: 0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  profile?.icon ?? Icons.person,
                                  size: 34,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile?.name ?? 'Guest',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppTheme.primaryOrange,
                                                Color(0xFFE85D04),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                          ),
                                          child: const Text(
                                            'PREMIUM',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Member since 2024',
                                          style: TextStyle(
                                            color: AppTheme.textGrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Edit button
                              IconButton(
                                onPressed: () {},
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Switch Profile button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => context.go('/profiles'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Switch Profile',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Quick Action Grid
                        Row(
                          children: [
                            Expanded(
                              child: _quickAction(
                                Icons.notifications_outlined,
                                'Notifications',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _quickAction(
                                Icons.download_outlined,
                                'Downloads',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _quickAction(
                                Icons.bookmark_outline,
                                'My List',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _quickAction(
                                Icons.history,
                                'Watch History',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Settings Groups
                        _settingsSection('Account', [
                          _settingsTile(
                            Icons.person_outline,
                            'Account Details',
                          ),
                          _settingsTile(
                            Icons.credit_card,
                            'Subscription & Billing',
                          ),
                          _settingsTile(Icons.devices, 'Manage Devices'),
                          _settingsTile(
                            Icons.family_restroom,
                            'Manage Profiles',
                          ),
                        ]),
                        const SizedBox(height: 20),

                        _settingsSection('Settings', [
                          _settingsTile(
                            Icons.high_quality,
                            'Video Quality',
                            subtitle: 'Auto',
                          ),
                          _settingsTile(
                            Icons.download_outlined,
                            'Download Settings',
                            subtitle: 'Wi-Fi Only',
                          ),
                          _settingsTile(
                            Icons.language,
                            'Language',
                            subtitle: 'English',
                          ),
                          _settingsTile(
                            Icons.subtitles,
                            'Subtitles',
                            subtitle: 'On',
                          ),
                          _settingsTile(
                            Icons.notifications_outlined,
                            'Notifications',
                            subtitle: 'Enabled',
                          ),
                        ]),
                        const SizedBox(height: 20),

                        _settingsSection('Help & More', [
                          _settingsTile(Icons.help_outline, 'Help Center'),
                          _settingsTile(
                            Icons.privacy_tip_outlined,
                            'Privacy Policy',
                          ),
                          _settingsTile(
                            Icons.description_outlined,
                            'Terms of Service',
                          ),
                          _settingsTile(
                            Icons.info_outline,
                            'About GospelVision',
                          ),
                        ]),
                        const SizedBox(height: 28),

                        // Sign Out button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.08,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Version
                        Center(
                          child: Text(
                            'GospelVisionTV v1.0.0',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.2),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart),
          ),
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textGrey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textGrey, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(color: AppTheme.textDimGrey, fontSize: 13),
            ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withValues(alpha: 0.3),
            size: 20,
          ),
        ],
      ),
    );
  }
}
