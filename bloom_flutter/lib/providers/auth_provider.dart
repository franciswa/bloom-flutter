import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../models/user.dart';
import '../services/analytics_service.dart';
import '../services/service_registry.dart';

/// Authentication provider
class AuthProvider extends ChangeNotifier {
  /// Current user
  User? _currentUser;

  /// Loading state
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Creates a new [AuthProvider] instance
  AuthProvider() {
    _init();
  }

  /// Initialize
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = ServiceRegistry.authService.getCurrentUser();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Listen for auth state changes
    ServiceRegistry.authService.getAuthStateChanges().listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        _currentUser = ServiceRegistry.authService.getCurrentUser();
        _errorMessage = null;
      } else if (event.event == AuthChangeEvent.signedOut) {
        // Handle sign out event
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  /// Get current user
  User? get currentUser => _currentUser;

  /// Is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Is profile complete
  bool get isProfileComplete {
    if (_currentUser == null) return false;

    // Check if user has a profile in the database
    // This is a simplified check - in a real app, you would check more fields
    try {
      // If getUserProfile succeeds (doesn't throw), the profile exists
      ServiceRegistry.profileService.getUserProfile(_currentUser!.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Sign in with email and password (convenience method)
  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    return signInWithEmailAndPassword(
        email: email, password: password, rememberMe: rememberMe);
  }

  /// Sign up with email and password (convenience method)
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    return signUpWithEmailAndPassword(email: email, password: password);
  }

  /// Check email verification status
  Future<bool> checkEmailVerification() async {
    if (_currentUser == null) return false;

    try {
      // Refresh user data
      final user = await ServiceRegistry.authService.refreshUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }

      return _currentUser?.emailConfirmed ?? false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  /// Resend verification email
  Future<void> resendVerificationEmail() async {
    if (_currentUser == null) {
      throw Exception('No user is signed in');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.authService
          .sendEmailVerification(email: _currentUser!.email);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser =
          await ServiceRegistry.authService.signInWithEmailAndPassword(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      // Track login event
      if (_currentUser != null) {
        await AnalyticsService.identifyUser(_currentUser!);
        await AnalyticsService.trackLogin('email');
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser =
          await ServiceRegistry.authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Track registration event
      if (_currentUser != null) {
        await AnalyticsService.identifyUser(_currentUser!);
        await AnalyticsService.trackRegistration('email');
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with phone and password
  Future<void> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser =
          await ServiceRegistry.authService.signInWithPhoneAndPassword(
        phone: phone,
        password: password,
      );

      // Track login event
      if (_currentUser != null) {
        await AnalyticsService.identifyUser(_currentUser!);
        await AnalyticsService.trackLogin('phone');
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign up with phone and password
  Future<void> signUpWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser =
          await ServiceRegistry.authService.signUpWithPhoneAndPassword(
        phone: phone,
        password: password,
      );

      // Track registration event
      if (_currentUser != null) {
        await AnalyticsService.identifyUser(_currentUser!);
        await AnalyticsService.trackRegistration('phone');
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await ServiceRegistry.authService.signInWithGoogle();

      // Track login event
      if (_currentUser != null) {
        await AnalyticsService.identifyUser(_currentUser!);
        await AnalyticsService.trackLogin('google');
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await ServiceRegistry.authService.signInWithApple();

      // Track login event
      if (_currentUser != null) {
        await AnalyticsService.identifyUser(_currentUser!);
        await AnalyticsService.trackLogin('apple');
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with Facebook
  Future<void> signInWithFacebook() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await ServiceRegistry.authService.signInWithOAuth(
        provider: OAuthProvider.facebook,
      );

      // Track login event
      if (_currentUser != null) {
        await AnalyticsService.identifyUser(_currentUser!);
        await AnalyticsService.trackLogin('facebook');
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Track logout event before signing out
      if (_currentUser != null) {
        await AnalyticsService.trackLogout();
      }

      await ServiceRegistry.authService.signOut();

      // Reset analytics user after logout
      await AnalyticsService.resetUser();

      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.authService.resetPassword(email: email);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update password
  Future<void> updatePassword({required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.authService.updatePassword(password: password);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update email
  Future<void> updateEmail({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.authService.updateEmail(email: email);
      _currentUser = _currentUser?.copyWith(email: email);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update phone
  Future<void> updatePhone({required String phone}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.authService.updatePhone(phone: phone);
      _currentUser = _currentUser?.copyWith(
        phone: () => phone,
      );
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Verify email
  Future<void> verifyEmail({
    required String token,
    required String type,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.authService.verifyEmail(token: token, type: type);
      _currentUser = _currentUser?.copyWith(emailConfirmed: true);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Verify phone
  Future<void> verifyPhone({
    required String token,
    required String type,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.authService.verifyPhone(token: token, type: type);
      _currentUser = _currentUser?.copyWith(phoneConfirmed: true);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Track account deletion event before deleting
      if (_currentUser != null) {
        await AnalyticsService.trackEvent('account_deleted');
      }

      await ServiceRegistry.authService.deleteAccount();

      // Reset analytics user after account deletion
      await AnalyticsService.resetUser();

      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
