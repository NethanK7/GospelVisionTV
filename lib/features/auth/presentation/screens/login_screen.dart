import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gv_tv/core/theme/app_colors.dart';
import 'package:gv_tv/core/common_widgets/gradient_background.dart';
import 'package:gv_tv/core/services/auth_service_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo or Brand Name
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ).animate().scale(
                  delay: 200.ms,
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),

                const SizedBox(height: 32),

                Text(
                  'GOSPEL VISION',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                Text(
                  'TV',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 12,
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),

                const Spacer(),

                // Login Buttons
                _buildSocialButton(
                  context,
                  icon: Icons.g_mobiledata_rounded,
                  label: 'Sign in with Google',
                  onPressed: () async {
                    final user = await authService.signInWithGoogle();
                    if (user != null && context.mounted) {
                      context.go('/');
                    }
                  },
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5, end: 0),

                const SizedBox(height: 16),

                _buildSocialButton(
                  context,
                  icon: Icons.email_outlined,
                  label: 'Continue with Email',
                  isPrimary: false,
                  onPressed: () {
                    // Navigate to email login or show dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email login coming soon!')),
                    );
                  },
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5, end: 0),

                const SizedBox(height: 32),

                // Development Skip Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(
                        Icons.code,
                        size: 16,
                        color: Colors.white38,
                      ),
                      label: const Text(
                        'DEV SKIP',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: () => context.push('/admin'),
                      icon: const Icon(
                        Icons.admin_panel_settings_outlined,
                        size: 16,
                        color: Colors.white38,
                      ),
                      label: const Text(
                        'ADMIN SKIP',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1100.ms),

                const Spacer(),

                Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ).animate().fadeIn(delay: 1200.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPrimary
            ? const LinearGradient(
                colors: [AppColors.brandOrange, Color(0xFFFF8C00)],
              )
            : null,
        color: isPrimary ? null : Colors.white.withValues(alpha: 0.05),
        border: isPrimary
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.brandOrange.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
