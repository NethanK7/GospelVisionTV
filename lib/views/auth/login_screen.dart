import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/profiles');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image / Gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1519681393784-d120267933ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),

          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/gv_logo.png',
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: -0.2, end: 0),

                    const SizedBox(height: 48),

                    // Glassmorphic Login Card
                    ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              width: isDesktop ? 400 : double.infinity,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 30,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(delay: 100.ms)
                                      .slideX(begin: -0.1, end: 0),

                                  const SizedBox(height: 32),

                                  // Email Input
                                  _buildInputField(
                                        controller: _emailController,
                                        label: 'Email Address',
                                        icon: Icons.email_outlined,
                                        isObscure: false,
                                      )
                                      .animate()
                                      .fadeIn(delay: 200.ms)
                                      .slideX(begin: 0.1, end: 0),

                                  const SizedBox(height: 24),

                                  // Password Input
                                  _buildInputField(
                                        controller: _passwordController,
                                        label: 'Password',
                                        icon: Icons.lock_outline,
                                        isObscure: true,
                                      )
                                      .animate()
                                      .fadeIn(delay: 300.ms)
                                      .slideX(begin: 0.1, end: 0),

                                  const SizedBox(height: 40),

                                  // Sign In Button
                                  SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: _isLoading
                                              ? null
                                              : _handleLogin,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppTheme.primaryOrange,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(delay: 400.ms)
                                      .scaleXY(begin: 0.9, end: 1.0),

                                  const SizedBox(height: 24),

                                  // Skip For Now Button
                                  Center(
                                    child: TextButton(
                                      onPressed: () => context.go('/profiles'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white
                                            .withValues(alpha: 0.7),
                                      ),
                                      child: const Text(
                                        'Skip for now',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 500.ms),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
