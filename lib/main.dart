import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Theme & Controllers
import 'theme/app_theme.dart';
import 'controllers/home_controller.dart';
import 'controllers/live_tv_controller.dart';
import 'controllers/search_controller.dart';

// Views
import 'views/splash/splash_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/profile/profile_selection_screen.dart';
import 'views/navigation/main_navigation.dart';
import 'views/home/home_screen.dart';
import 'views/news/news_screen.dart';
import 'views/live_tv/live_tv_screen.dart';
import 'views/settings/settings_screen.dart';
import 'views/detail/content_detail_screen.dart';
import 'views/movies/movie_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => LiveTvController()),
        ChangeNotifierProvider(create: (_) => ContentSearchController()),
      ],
      child: const GospelVisionApp(),
    ),
  );
}

// GoRouter configuration
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // Splash Screen
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    // Login Screen
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // Profile Selection
    GoRoute(
      path: '/profiles',
      builder: (context, state) => const ProfileSelectionScreen(),
    ),

    // Content Detail (full-screen overlay)
    GoRoute(
      path: '/detail/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ContentDetailScreen(contentId: id);
      },
    ),

    // Main App Shell (tabbed navigation)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Branch 1: Live TV
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/livetv',
              builder: (context, state) => const LiveTvScreen(),
            ),
          ],
        ),
        // Branch 2: Movies
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/movies',
              builder: (context, state) => const MovieScreen(),
            ),
          ],
        ),
        // Branch 3: News
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/news',
              builder: (context, state) => const NewsScreen(),
            ),
          ],
        ),
        // Branch 4: Settings / My GospelVision
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class GospelVisionApp extends StatelessWidget {
  const GospelVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GospelVisionTV',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
