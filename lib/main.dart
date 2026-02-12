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
import 'package:gv_tv/features/admin/views/screens/admin_dashboard.dart';
import 'package:gv_tv/features/admin/views/screens/user_management_screen.dart';
import 'package:gv_tv/features/movies/presentation/screens/movie_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gv_tv/features/home/providers/home_provider.dart';
import 'package:gv_tv/core/services/auth_service_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Initialize Isar (Local Database)
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open([UserProfileSchema], directory: dir.path);

  // 3. Seed initial data if needed
  // await DatabaseSeeder.seedInitialData(); // User wants it blank

  runApp(const ProviderScope(child: GospelVisionApp()));
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
        GoRoute(
          path: '/movie-detail',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: MovieDetailScreen(
                title: extra?['title'],
                imageUrl: extra?['imageUrl'],
                description: extra?['description'],
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeOutCubic)),
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AdminDashboard(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: 'users',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const UserManagementScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
      ],
    ),
  ],
);
