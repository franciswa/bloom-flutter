import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:bloom_flutter/models/user.dart';
import 'package:bloom_flutter/services/auth_service.dart';

// Create mocks
class MockGoTrueClient extends Mock implements supabase.GoTrueClient {}

class MockAuthResponse extends Mock implements supabase.AuthResponse {}

class MockUserResponse extends Mock implements supabase.UserResponse {}

class MockSession extends Mock implements supabase.Session {}

class MockSupabaseUser extends Mock implements supabase.User {}

void main() {
  late AuthService authService;
  late MockGoTrueClient mockAuth;
  late MockSupabaseUser mockUser;

  // We need to use a simpler approach for testing since we can't easily mock static classes
  setUp(() {
    // Initialize mocks
    mockAuth = MockGoTrueClient();
    mockUser = MockSupabaseUser();

    // Set up default mock behavior
    when(() => mockUser.id).thenReturn('test-user-id');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.phone).thenReturn('+15555555555');
    when(() => mockUser.createdAt).thenReturn('2023-01-01T00:00:00.000Z');
    when(() => mockUser.updatedAt).thenReturn('2023-01-01T00:00:00.000Z');
    when(() => mockUser.lastSignInAt).thenReturn('2023-01-01T00:00:00.000Z');
    when(() => mockUser.emailConfirmedAt)
        .thenReturn('2023-01-01T00:00:00.000Z');
    when(() => mockUser.phoneConfirmedAt)
        .thenReturn('2023-01-01T00:00:00.000Z');

    // Create the auth service
    authService = AuthService();

    // Reset the demo mode
    isDemoMode = false;
  });

  group('AuthService - Demo Mode Tests', () {
    test('demo mode returns demo user', () {
      // Arrange
      isDemoMode = true;

      // Act
      final user = authService.getCurrentUser();

      // Assert
      expect(user, isNotNull);
      expect(user!.id, equals('demo-user-123'));
      expect(user.email, equals('demo@example.com'));
      expect(user.phone, equals('+15555555555'));
      expect(user.emailConfirmed, isTrue);
      expect(user.phoneConfirmed, isTrue);
    });

    test('demo mode signInWithEmailAndPassword returns demo user', () async {
      // Arrange
      isDemoMode = true;

      // Act
      final user = await authService.signInWithEmailAndPassword(
        email: 'any@example.com',
        password: 'anypassword',
      );

      // Assert
      expect(user, isNotNull);
      expect(user.id, equals('demo-user-123'));
      expect(user.email, equals('demo@example.com'));
      expect(user.phone, equals('+15555555555'));
      expect(user.emailConfirmed, isTrue);
      expect(user.phoneConfirmed, isTrue);
    });

    test('demo mode signUpWithEmailAndPassword returns demo user', () async {
      // Arrange
      isDemoMode = true;

      // Act
      final user = await authService.signUpWithEmailAndPassword(
        email: 'any@example.com',
        password: 'anypassword',
      );

      // Assert
      expect(user, isNotNull);
      expect(user.id, equals('demo-user-123'));
      expect(user.email, equals('demo@example.com'));
      expect(user.phone, equals('+15555555555'));
      expect(user.emailConfirmed, isTrue);
      expect(user.phoneConfirmed, isTrue);
    });

    test('demo mode isSignedIn returns true', () {
      // Arrange
      isDemoMode = true;

      // Act & Assert
      expect(authService.isSignedIn(), isTrue);
    });

    test('demo mode isEmailVerified returns true', () {
      // Arrange
      isDemoMode = true;

      // Act & Assert
      expect(authService.isEmailVerified(), isTrue);
    });

    test('demo mode isPhoneVerified returns true', () {
      // Arrange
      isDemoMode = true;

      // Act & Assert
      expect(authService.isPhoneVerified(), isTrue);
    });
  });
}
