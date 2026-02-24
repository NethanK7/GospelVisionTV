import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          _buildProfileSection(),
          const Divider(color: Colors.grey, height: 32),
          _buildSettingsGroup(
            title: 'Account Settings',
            children: [
              _buildListTile(Icons.email, 'Email Address', 'user@example.com'),
              _buildListTile(Icons.lock, 'Password', '********'),
              _buildListTile(
                Icons.subscriptions,
                'Subscription',
                'Premium Plan',
              ),
            ],
          ),
          const Divider(color: Colors.grey, height: 32),
          _buildSettingsGroup(
            title: 'App Settings',
            children: [
              _buildListTile(Icons.video_settings, 'Video Quality', 'Auto'),
              _buildListTile(Icons.download, 'Downloads', 'Wi-Fi Only'),
              _buildListTile(Icons.notifications, 'Notifications', 'Enabled'),
            ],
          ),
          const Divider(color: Colors.grey, height: 32),
          _buildSettingsGroup(
            title: 'Help & Support',
            children: [
              _buildListTile(
                Icons.help_center,
                'Help Centre',
                'FAQs & Contact',
              ),
              _buildListTile(Icons.privacy_tip, 'Privacy Policy', ''),
              _buildListTile(Icons.description, 'Terms of Service', ''),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Sign Out',
                style: TextStyle(color: AppTheme.primaryOrange, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gospel Vision Viewer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Premium Member',
                style: TextStyle(fontSize: 14, color: AppTheme.primaryOrange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textGrey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: const TextStyle(color: AppTheme.textGrey))
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
      onTap: () {},
    );
  }
}
