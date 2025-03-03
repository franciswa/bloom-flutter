import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloom_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Verify app startup and navigation to login screen',
        (WidgetTester tester) async {
      // Start the app
      app.main();

      // Wait for the app to fully load
      await tester.pumpAndSettle();

      // Verify that the splash screen is displayed initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for splash screen to complete (this might need adjustment based on your splash screen duration)
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify navigation to login or onboarding screen
      // This will depend on your app's flow, but typically it will show either:
      // - Login screen for returning users
      // - Onboarding screen for new users
      // For this test, we'll check for common elements that would be on either screen
      expect(
        find.byWidgetPredicate((widget) =>
            widget is Text &&
            (widget.data?.contains('Sign In') == true ||
                widget.data?.contains('Welcome') == true)),
        findsOneWidget,
      );

      // If on login screen, verify login form elements
      if (find.text('Sign In').evaluate().isNotEmpty) {
        // Verify email and password fields
        expect(find.byType(TextFormField), findsAtLeast(2));

        // Verify login button
        expect(find.byType(ElevatedButton), findsOneWidget);

        // Verify "Forgot Password" link
        expect(find.text('Forgot Password?'), findsOneWidget);

        // Verify "Sign Up" link
        expect(find.textContaining('Sign Up'), findsOneWidget);
      }
      // If on onboarding screen, verify onboarding elements
      else if (find.text('Welcome').evaluate().isNotEmpty) {
        // Verify "Get Started" or similar button
        expect(
          find.byWidgetPredicate((widget) =>
              widget is ElevatedButton ||
              (widget is Text &&
                  (widget.data?.contains('Get Started') == true ||
                      widget.data?.contains('Next') == true))),
          findsOneWidget,
        );
      }
    });

    // Additional tests could be added here to test:
    // - Login flow
    // - Registration flow
    // - Navigation between main screens
    // - Profile creation
    // - Matching functionality
    // - Messaging
    // - Settings changes
  });
}
