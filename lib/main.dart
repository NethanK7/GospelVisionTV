import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gv_tv/core/models/user_profile.dart';
import 'package:gv_tv/core/theme/app_theme.dart';
import 'package:gv_tv/features/splash/presentation/screens/splash_screen.dart';
import 'package:gv_tv/features/auth/presentation/screens/login_screen.dart';
import 'package:gv_tv/features/home/views/screens/home_screen.dart';
import 'package:gv_tv/features/live_tv/presentation/screens/live_tv_screen.dart';
import 'package:gv_tv/features/movies/presentation/screens/movies_screen.dart';
import 'package:gv_tv/features/news/presentation/screens/news_screen.dart';
import 'package:gv_tv/features/profile/presentation/screens/profile_screen.dart';
import 'package:gv_tv/core/presentation/navigation/main_navigation_shell.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Initialize Isar (Local Database)
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open([UserProfileSchema], directory: dir.path);

  runApp(const GospelVisionApp());
}

class GospelVisionApp extends StatelessWidget {
  const GospelVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GospelVision.TV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Supports automatic light/dark switching
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            ),
          );
        },
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => MainNavigationShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const HomeScreen()),
        ),
        GoRoute(
          path: '/live',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const LiveTvScreen()),
        ),
        GoRoute(
          path: '/movies',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const MoviesScreen()),
        ),
        GoRoute(
          path: '/news',
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const NewsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ProfileScreen(),
          ),
        ),
      ],
    ),
  ],
);
