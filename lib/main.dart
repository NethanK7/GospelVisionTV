import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Theme & Controllers
import 'theme/app_theme.dart';
import 'controllers/home_controller.dart';
import 'controllers/live_tv_controller.dart';

// Views
import 'views/navigation/main_navigation.dart';
import 'views/home/home_screen.dart';
import 'views/news/news_screen.dart';
import 'views/live_tv/live_tv_screen.dart';
import 'views/settings/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => LiveTvController()),
      ],
      child: const GospelVisionApp(),
    ),
  );
}

// GoRouter configuration
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
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
        // Branch 1: News
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/news',
              builder: (context, state) => const NewsScreen(),
            ),
          ],
        ),
        // Branch 2: Live TV
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/livetv',
              builder: (context, state) => const LiveTvScreen(),
            ),
          ],
        ),
        // Branch 3: Settings
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
