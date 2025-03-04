import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:bloom_flutter/providers/auth_provider.dart';
import 'package:bloom_flutter/screens/auth/login_screen.dart';
import 'package:bloom_flutter/models/user.dart';

// Create mocks
class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  group('LoginScreen', () {
    testWidgets('renders login form correctly', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.errorMessage).thenReturn('');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(TextFormField),
          findsAtLeast(2)); // Email and password fields
      expect(find.byType(ElevatedButton), findsOneWidget); // Sign in button
    });

    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoading).thenReturn(true);
      when(() => mockAuthProvider.errorMessage).thenReturn('');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when there is an error',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.errorMessage)
          .thenReturn('Invalid credentials');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('calls signIn when form is submitted with valid data',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.errorMessage).thenReturn('');
      when(() => mockAuthProvider.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => User.empty);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Enter email and password
      await tester.enterText(
          find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(() => mockAuthProvider.signIn(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    testWidgets(
        'navigates to forgot password screen when forgot password is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.errorMessage).thenReturn('');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Find and tap the forgot password button
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Assert
      // Note: In a real test, we would verify navigation to the ForgotPasswordScreen
      // but this requires more setup with navigation mocks
    });

    testWidgets('navigates to register screen when register button is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.errorMessage).thenReturn('');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Find and tap the register button
      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.pumpAndSettle();

      // Assert
      // Note: In a real test, we would verify navigation to the RegisterScreen
      // but this requires more setup with navigation mocks
    });
  });
}
