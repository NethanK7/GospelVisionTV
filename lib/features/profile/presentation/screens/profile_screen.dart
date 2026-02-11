import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Header Section with Glassy Entrance
            Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.brandOrange.withValues(alpha: 0.2),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandOrange.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.brandOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.8, 0.8)),

            const SizedBox(height: 24),

            Text(
              'Faithful Believer',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 4),

            Text(
              'Premium Member since 2024',
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 40),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard(
                    context,
                    'Favorites',
                    '12',
                    Icons.favorite_rounded,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Completed',
                    '45',
                    Icons.check_circle_rounded,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Crowns',
                    '1.2k',
                    Icons.workspace_premium_rounded,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 40),

            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACCOUNT SETTINGS',
                    style: TextStyle(
                      color: isDark ? Colors.white24 : Colors.black26,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    context,
                    itemGroups: [
                      _SettingItem(
                        Icons.history_rounded,
                        'Viewing History',
                        'See what you watched',
                      ),
                      _SettingItem(
                        Icons.payment_rounded,
                        'Subscription',
                        'Manage your plan',
                      ),
                      _SettingItem(
                        Icons.download_for_offline_rounded,
                        'Downloads',
                        'Manage offline data',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PREFERENCES',
                    style: TextStyle(
                      color: isDark ? Colors.white24 : Colors.black26,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    context,
                    itemGroups: [
                      _SettingItem(
                        Icons.video_settings_rounded,
                        'Video Quality',
                        'Auto',
                      ),
                      _SettingItem(
                        Icons.notifications_active_rounded,
                        'Push Notifications',
                        'On',
                      ),
                      _SettingItem(
                        Icons.help_center_rounded,
                        'Help & Support',
                        '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.red.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: const Text(
                      'LOG OUT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.05,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.brandOrange, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required List<_SettingItem> itemGroups,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: itemGroups.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    color: AppColors.brandOrange,
                    size: 22,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: item.subtitle.isNotEmpty
                    ? Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      )
                    : null,
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
                onTap: () {},
              ),
              if (idx < itemGroups.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.05,
                    ),
                    height: 1,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  _SettingItem(this.icon, this.title, this.subtitle);
}
