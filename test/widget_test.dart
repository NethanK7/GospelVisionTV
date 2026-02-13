// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:gv_tv/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gv_tv/features/splash/presentation/screens/splash_screen.dart';
import 'package:gv_tv/core/services/auth_service_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthService implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<User?> get user => Stream.value(null);

  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<String> getUserRole(String uid) async => 'user';
}

void main() {
  testWidgets('App starts with Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(MockAuthService())],
        child: const GospelVisionApp(),
      ),
    );

    // Verify that we are on the Splash Screen
    expect(find.byType(SplashScreen), findsOneWidget);

    // Settle the splash screen timer and animations
    // Using 5 seconds to be safe as splash has 3s delay
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
