import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../models/user.dart';
import 'analytics_service.dart';
import 'supabase_service.dart';

/// Flag to enable demo mode without actual authentication
bool isDemoMode = false;

/// Authentication service
class AuthService {
  /// Mock user for demo mode
  final User _demoUser = User(
    id: 'demo-user-123',
    email: 'demo@example.com',
    phone: '+15555555555',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
    lastSignIn: DateTime.now(),
    emailConfirmed: true,
    phoneConfirmed: true,
    banned: false,
    deleted: false,
  );

  /// Get current user
  User? getCurrentUser() {
    // Return demo user if in demo mode
    if (isDemoMode) {
      return _demoUser;
    }

    final supabaseUser = SupabaseService.currentUser;
    if (supabaseUser == null) {
      return null;
    }

    final createdAtStr = supabaseUser.createdAt;
    final updatedAtStr = supabaseUser.updatedAt;

    // Handle potentially null createdAt and updatedAt strings
    final DateTime createdAt =
        createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
    final DateTime updatedAt =
        updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

    return User(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      phone: supabaseUser.phone ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastSignIn: supabaseUser.lastSignInAt != null
          ? DateTime.parse(supabaseUser.lastSignInAt!)
          : null,
      emailConfirmed: supabaseUser.emailConfirmedAt != null,
      phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
      banned: false,
      deleted: false,
    );
  }

  /// Sign in with email and password
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Return demo user if in demo mode
    if (isDemoMode) {
      // Track login event for analytics in demo mode
      await AnalyticsService.trackLogin('email');
      await AnalyticsService.identifyUser(_demoUser);
      return _demoUser;
    }

    try {
      final response = await SupabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw Exception('Failed to sign in');
      }

      final createdAtStr = supabaseUser.createdAt;
      final updatedAtStr = supabaseUser.updatedAt;

      // Handle potentially null createdAt and updatedAt strings
      final DateTime createdAt =
          createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      final DateTime updatedAt =
          updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

      final user = User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        phone: supabaseUser.phone ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignIn: supabaseUser.lastSignInAt != null
            ? DateTime.parse(supabaseUser.lastSignInAt!)
            : null,
        emailConfirmed: supabaseUser.emailConfirmedAt != null,
        phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
        banned: false,
        deleted: false,
      );

      // Track login event
      await AnalyticsService.trackLogin('email');
      await AnalyticsService.identifyUser(user);

      return user;
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign in with email: ${e.toString()}',
        errorSource: 'AuthService.signInWithEmailAndPassword',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Return demo user if in demo mode
    if (isDemoMode) {
      // Track registration event for analytics in demo mode
      await AnalyticsService.trackRegistration('email');
      await AnalyticsService.identifyUser(_demoUser);
      return _demoUser;
    }

    try {
      final response = await SupabaseService.auth.signUp(
        email: email,
        password: password,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw Exception('Failed to sign up');
      }

      final createdAtStr = supabaseUser.createdAt;
      final updatedAtStr = supabaseUser.updatedAt;

      // Handle potentially null createdAt and updatedAt strings
      final DateTime createdAt =
          createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      final DateTime updatedAt =
          updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

      final user = User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        phone: supabaseUser.phone ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignIn: supabaseUser.lastSignInAt != null
            ? DateTime.parse(supabaseUser.lastSignInAt!)
            : null,
        emailConfirmed: supabaseUser.emailConfirmedAt != null,
        phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
        banned: false,
        deleted: false,
      );

      // Track registration event
      await AnalyticsService.trackRegistration('email');
      await AnalyticsService.identifyUser(user);

      return user;
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign up with email: ${e.toString()}',
        errorSource: 'AuthService.signUpWithEmailAndPassword',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Sign in with phone and password
  Future<User> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.auth.signInWithPassword(
        phone: phone,
        password: password,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw Exception('Failed to sign in');
      }

      final createdAtStr = supabaseUser.createdAt;
      final updatedAtStr = supabaseUser.updatedAt;

      // Handle potentially null createdAt and updatedAt strings
      final DateTime createdAt =
          createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      final DateTime updatedAt =
          updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

      final user = User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        phone: supabaseUser.phone ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignIn: supabaseUser.lastSignInAt != null
            ? DateTime.parse(supabaseUser.lastSignInAt!)
            : null,
        emailConfirmed: supabaseUser.emailConfirmedAt != null,
        phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
        banned: false,
        deleted: false,
      );

      // Track login event
      await AnalyticsService.trackLogin('phone');
      await AnalyticsService.identifyUser(user);

      return user;
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign in with phone: ${e.toString()}',
        errorSource: 'AuthService.signInWithPhoneAndPassword',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Sign up with phone and password
  Future<User> signUpWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.auth.signUp(
        phone: phone,
        password: password,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw Exception('Failed to sign up');
      }

      final createdAtStr = supabaseUser.createdAt;
      final updatedAtStr = supabaseUser.updatedAt;

      // Handle potentially null createdAt and updatedAt strings
      final DateTime createdAt =
          createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      final DateTime updatedAt =
          updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

      final user = User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        phone: supabaseUser.phone ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignIn: supabaseUser.lastSignInAt != null
            ? DateTime.parse(supabaseUser.lastSignInAt!)
            : null,
        emailConfirmed: supabaseUser.emailConfirmedAt != null,
        phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
        banned: false,
        deleted: false,
      );

      // Track registration event
      await AnalyticsService.trackRegistration('phone');
      await AnalyticsService.identifyUser(user);

      return user;
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign up with phone: ${e.toString()}',
        errorSource: 'AuthService.signUpWithPhoneAndPassword',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Sign in with OAuth provider
  Future<User> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
  }) async {
    try {
      await SupabaseService.auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
      );

      final supabaseUser = SupabaseService.currentUser;
      if (supabaseUser == null) {
        throw Exception('Failed to sign in with OAuth');
      }

      final createdAtStr = supabaseUser.createdAt;
      final updatedAtStr = supabaseUser.updatedAt;

      // Handle potentially null createdAt and updatedAt strings
      final DateTime createdAt =
          createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      final DateTime updatedAt =
          updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

      final user = User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        phone: supabaseUser.phone ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignIn: supabaseUser.lastSignInAt != null
            ? DateTime.parse(supabaseUser.lastSignInAt!)
            : null,
        emailConfirmed: supabaseUser.emailConfirmedAt != null,
        phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
        banned: false,
        deleted: false,
      );

      // Track login event
      await AnalyticsService.trackLogin(provider.toString().toLowerCase());
      await AnalyticsService.identifyUser(user);

      return user;
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign in with OAuth: ${e.toString()}',
        errorSource: 'AuthService.signInWithOAuth',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Track logout event before signing out
      await AnalyticsService.trackLogout();
      await AnalyticsService.resetUser();

      // Sign out
      await SupabaseService.auth.signOut();
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign out: ${e.toString()}',
        errorSource: 'AuthService.signOut',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    await SupabaseService.auth.resetPasswordForEmail(
      email,
    );
  }

  /// Update password
  Future<void> updatePassword({required String password}) async {
    await SupabaseService.auth.updateUser(
      UserAttributes(
        password: password,
      ),
    );
  }

  /// Update email
  Future<void> updateEmail({required String email}) async {
    await SupabaseService.auth.updateUser(
      UserAttributes(
        email: email,
      ),
    );
  }

  /// Update phone
  Future<void> updatePhone({required String phone}) async {
    await SupabaseService.auth.updateUser(
      UserAttributes(
        phone: phone,
      ),
    );
  }

  /// Verify email
  Future<void> verifyEmail(
      {required String token, required String type}) async {
    await SupabaseService.auth.verifyOTP(
      token: token,
      type: OtpType.email,
    );
  }

  /// Verify phone
  Future<void> verifyPhone(
      {required String token, required String type}) async {
    await SupabaseService.auth.verifyOTP(
      token: token,
      type: OtpType.sms,
    );
  }

  /// Delete account
  Future<void> deleteAccount() async {
    final userId = SupabaseService.userId;
    if (userId == null) {
      throw Exception('No user is signed in');
    }

    await SupabaseService.auth.admin.deleteUser(userId);
  }

  /// Get auth state changes
  Stream<AuthState> getAuthStateChanges() {
    return SupabaseService.onAuthStateChange;
  }

  /// Is signed in
  bool isSignedIn() {
    if (isDemoMode) {
      return true; // Always signed in when in demo mode
    }
    return SupabaseService.isSignedIn;
  }

  /// Is email verified
  bool isEmailVerified() {
    if (isDemoMode) {
      return true; // Always verified when in demo mode
    }
    return SupabaseService.isEmailConfirmed;
  }

  /// Is phone verified
  bool isPhoneVerified() {
    if (isDemoMode) {
      return true; // Always verified when in demo mode
    }
    return SupabaseService.isPhoneConfirmed;
  }

  /// Refresh user data
  Future<User?> refreshUser() async {
    try {
      // Get the latest user data from Supabase
      await SupabaseService.auth.refreshSession();

      // Return the updated user
      return getCurrentUser();
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to refresh user: ${e.toString()}',
        errorSource: 'AuthService.refreshUser',
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification({required String email}) async {
    try {
      await SupabaseService.auth.resend(
        type: OtpType.email,
        email: email,
      );
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to send email verification: ${e.toString()}',
        errorSource: 'AuthService.sendEmailVerification',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Generate a random string for state
  String _generateRandomString([int length = 32]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  /// Sign in with Google
  Future<User> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Sign in with Supabase using the Google credentials
      final response = await SupabaseService.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw Exception('Failed to sign in with Google');
      }

      final createdAtStr = supabaseUser.createdAt;
      final updatedAtStr = supabaseUser.updatedAt;

      // Handle potentially null createdAt and updatedAt strings
      final DateTime createdAt =
          createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      final DateTime updatedAt =
          updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

      final user = User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        phone: supabaseUser.phone ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignIn: supabaseUser.lastSignInAt != null
            ? DateTime.parse(supabaseUser.lastSignInAt!)
            : null,
        emailConfirmed: supabaseUser.emailConfirmedAt != null,
        phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
        banned: false,
        deleted: false,
      );

      // Track login event
      await AnalyticsService.trackLogin('google');
      await AnalyticsService.identifyUser(user);

      return user;
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign in with Google: ${e.toString()}',
        errorSource: 'AuthService.signInWithGoogle',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<User> signInWithApple() async {
    try {
      // Generate a random nonce
      final rawNonce = _generateRandomString();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Request Apple credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Sign in with Supabase using the Apple credentials
      final response = await SupabaseService.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
        nonce: nonce,
      );

      final supabaseUser = response.user;
      if (supabaseUser == null) {
        throw Exception('Failed to sign in with Apple');
      }

      final createdAtStr = supabaseUser.createdAt;
      final updatedAtStr = supabaseUser.updatedAt;

      // Handle potentially null createdAt and updatedAt strings
      final DateTime createdAt =
          createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
      final DateTime updatedAt =
          updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now();

      final user = User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        phone: supabaseUser.phone ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignIn: supabaseUser.lastSignInAt != null
            ? DateTime.parse(supabaseUser.lastSignInAt!)
            : null,
        emailConfirmed: supabaseUser.emailConfirmedAt != null,
        phoneConfirmed: supabaseUser.phoneConfirmedAt != null,
        banned: false,
        deleted: false,
      );

      // Track login event
      await AnalyticsService.trackLogin('apple');
      await AnalyticsService.identifyUser(user);

      return user;
    } catch (e, stackTrace) {
      // Track error
      await AnalyticsService.trackError(
        errorMessage: 'Failed to sign in with Apple: ${e.toString()}',
        errorSource: 'AuthService.signInWithApple',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Create user profile
  Future<void> createUserProfile({
    required String userId,
    required String displayName,
    required String firstName,
    String? lastName,
    required DateTime birthDate,
    String? birthTime,
    required String birthLocation,
    double? birthLatitude,
    double? birthLongitude,
  }) async {
    if (isDemoMode) {
      // In demo mode, just return without creating a profile in the database
      return;
    }

    await SupabaseService.from('profiles').insert({
      'user_id': userId,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate.toIso8601String(),
      'birth_time': birthTime,
      'birth_location': birthLocation,
      'birth_latitude': birthLatitude,
      'birth_longitude': birthLongitude,
      'gender': 'preferNotToSay',
      'looking_for': 'everyone',
      'photo_urls': [],
      'is_profile_complete': false,
      'is_profile_visible': false,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).select();
  }
}
