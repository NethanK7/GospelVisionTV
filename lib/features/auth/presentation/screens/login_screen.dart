import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:gv_tv/core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Animated Fire Background (The Orange Part)
          ...List.generate(6, (i) {
            final size = 200.0 + (i * 50);
            return Positioned(
              top: -100 + (i * 20),
              left: (i % 2 == 0) ? -50 : null,
              right: (i % 2 != 0) ? -50 : null,
              child:
                  Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.brandOrange.withValues(alpha: 0.3),
                              AppColors.brandOrange.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.5, 1.5),
                        duration: (3000 + i * 500).ms,
                        curve: Curves.easeInOutBack,
                      )
                      .blur(
                        begin: const Offset(20, 20),
                        end: const Offset(40, 40),
                      )
                      .moveY(
                        begin: -20,
                        end: 50,
                        duration: (4000 + i * 1000).ms,
                      ),
            );
          }),

          // 2. Rising Embers Effect
          ...List.generate(15, (i) {
            return Positioned(
              bottom: -20,
              left: (i * 25.0) % MediaQuery.of(context).size.width,
              child:
                  Container(
                        width: 2,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.brandOrange,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandOrange.withValues(
                                alpha: 0.8,
                              ),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .moveY(
                        begin: 0,
                        end: -MediaQuery.of(context).size.height,
                        duration: (3000 + i * 200).ms,
                      )
                      .fadeOut(delay: (2000 + i * 100).ms),
            );
          }),

          // 3. Black to Orange Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 4. Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Hero Logo Area - Revolve around this
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient Glow behind logo
                      Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brandOrange.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 100,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.2, 1.2),
                            duration: 2.seconds,
                          ),

                      Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 120,
                            ),
                          )
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.easeOutBack)
                          .fadeIn(),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Text(
                    'GospelVision.TV',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 8),

                  Text(
                    'Your Daily Spiritual Connection',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 48),

                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    hint: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // Password Field
                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onToggleVisibility: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // Sign In Button
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.brandOrange,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).scale(),

                  const SizedBox(height: 24),

                  // Separator
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: 24),

                  // Google Login Button
                  _buildGoogleLoginButton(
                    context,
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: 40),

                  TextButton(
                    onPressed: () => context.go('/'),
                    child: Text(
                      'CONTINUE AS GUEST',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ).animate().fadeIn(delay: 900.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
              height: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
