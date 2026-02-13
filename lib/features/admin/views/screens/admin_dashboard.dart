import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/core/theme/app_colors.dart';
import 'package:gv_tv/features/admin/views/screens/add_content_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'ADMIN CONTROL CENTER',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 16,
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(context),
            const SizedBox(height: 40),
            Text(
              'CONTENT MANAGEMENT',
              style: TextStyle(
                color: AppColors.brandOrange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAdminCard(
                  context,
                  title: 'Manage News',
                  icon: Icons.newspaper_rounded,
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddContentScreen(contentType: 'news'),
                    ),
                  ),
                ),
                _buildAdminCard(
                  context,
                  title: 'Add Movie',
                  icon: Icons.movie_filter_rounded,
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddContentScreen(contentType: 'movie'),
                    ),
                  ),
                ),
                _buildAdminCard(
                  context,
                  title: 'User Roles',
                  icon: Icons.people_alt_rounded,
                  color: Colors.orange,
                  onTap: () => context.push('/admin/users'),
                ),
                _buildAdminCard(
                  context,
                  title: 'User Analytics',
                  icon: Icons.analytics_rounded,
                  color: Colors.green,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildSystemHealthCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Command Center',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your cinematic experience from here.',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : AppColors.lightTextSecondary,
            fontSize: 14,
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack);
  }

  Widget _buildSystemHealthCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  Colors.white.withValues(alpha: 0.02),
                  Colors.white.withValues(alpha: 0.05),
                ]
              : [
                  Colors.black.withValues(alpha: 0.02),
                  Colors.black.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.security_rounded, color: AppColors.premiumGold),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Firebase Guard Active',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Connected to gospelvisiontv-5f3eb',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'ONLINE',
              style: TextStyle(
                color: Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}
