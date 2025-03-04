import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service
class SupabaseService {
  /// Private constructor to prevent instantiation
  const SupabaseService._();

  /// Flag to track if Supabase is initialized
  static bool _isInitialized = false;

  /// Set initialization status
  static void setInitialized(bool status) {
    _isInitialized = status;
  }

  /// Check if Supabase is initialized
  static bool get isInitialized => _isInitialized;

  /// Supabase client
  static SupabaseClient get client {
    if (!_isInitialized) {
      if (kDebugMode) {
        print(
            'Warning: Supabase is not initialized yet. Using fallback or returning null.');
      }
      // For web or when not initialized, provide a fallback or throw a more descriptive error
      if (kIsWeb) {
        throw Exception(
            'Supabase is not initialized for web platform. Please initialize Supabase before using it.');
      }
      throw Exception(
          'You must initialize the supabase instance before calling Supabase.instance');
    }
    return Supabase.instance.client;
  }

  /// Supabase auth
  static GoTrueClient get auth {
    if (!_isInitialized) {
      if (kDebugMode) {
        print(
            'Warning: Supabase is not initialized yet. Using fallback for auth.');
      }
      // Return a mock or throw a descriptive error
      throw Exception(
          'Supabase auth is not available because Supabase is not initialized');
    }
    return client.auth;
  }

  /// Supabase storage
  static SupabaseStorageClient get storage {
    if (!_isInitialized) {
      throw Exception(
          'Supabase storage is not available because Supabase is not initialized');
    }
    return client.storage;
  }

  /// Supabase functions
  static FunctionsClient get functions {
    if (!_isInitialized) {
      throw Exception(
          'Supabase functions are not available because Supabase is not initialized');
    }
    return client.functions;
  }

  /// Supabase realtime
  static RealtimeClient get realtime {
    if (!_isInitialized) {
      throw Exception(
          'Supabase realtime is not available because Supabase is not initialized');
    }
    return client.realtime;
  }

  /// Create a channel
  static RealtimeChannel channel(String name) {
    if (!_isInitialized) {
      throw Exception(
          'Cannot create Supabase channel because Supabase is not initialized');
    }
    return client.channel(name);
  }

  /// Get auth state changes
  static Stream<AuthState> get onAuthStateChange {
    if (!_isInitialized) {
      // Return an empty stream when not initialized
      return Stream.empty();
    }
    return auth.onAuthStateChange;
  }

  /// Get current user
  static User? get currentUser {
    if (!_isInitialized) {
      return null;
    }
    return auth.currentUser;
  }

  /// Is signed in
  static bool get isSignedIn {
    if (!_isInitialized) {
      return false;
    }
    return currentUser != null;
  }

  /// Get current session
  static Session? get currentSession {
    if (!_isInitialized) {
      return null;
    }
    return auth.currentSession;
  }

  /// Get user ID
  static String? get userId {
    if (!_isInitialized) {
      return null;
    }
    return currentUser?.id;
  }

  /// Get user email
  static String? get userEmail {
    if (!_isInitialized) {
      return null;
    }
    return currentUser?.email;
  }

  /// Get user phone
  static String? get userPhone {
    if (!_isInitialized) {
      return null;
    }
    return currentUser?.phone;
  }

  /// Is email confirmed
  static bool get isEmailConfirmed {
    if (!_isInitialized) {
      return false;
    }
    return currentUser?.emailConfirmedAt != null;
  }

  /// Is phone confirmed
  static bool get isPhoneConfirmed {
    if (!_isInitialized) {
      return false;
    }
    return currentUser?.phoneConfirmedAt != null;
  }

  /// Get last sign in
  static DateTime? get lastSignIn {
    if (!_isInitialized) {
      return null;
    }
    final signInAt = currentUser?.lastSignInAt;
    if (signInAt == null) return null;
    return DateTime.parse(signInAt);
  }

  /// Get created at
  static DateTime? get createdAt {
    if (!_isInitialized) {
      return null;
    }
    final created = currentUser?.createdAt;
    if (created == null) return null;
    return DateTime.parse(created);
  }

  /// Get updated at
  static DateTime? get updatedAt {
    if (!_isInitialized) {
      return null;
    }
    final updated = currentUser?.updatedAt;
    if (updated == null) return null;
    return DateTime.parse(updated);
  }

  /// Get from table
  static dynamic from<T>(String table) {
    if (!_isInitialized) {
      throw Exception(
          'Cannot access Supabase table because Supabase is not initialized');
    }
    return client.from(table);
  }

  /// Get from table with RLS bypass
  static dynamic fromWithRLS<T>(String table) {
    if (!_isInitialized) {
      throw Exception(
          'Cannot access Supabase table because Supabase is not initialized');
    }
    return client.from(table);
  }

  /// Get from storage bucket
  static dynamic fromBucket(String bucket) {
    if (!_isInitialized) {
      throw Exception(
          'Cannot access Supabase storage bucket because Supabase is not initialized');
    }
    return storage.from(bucket);
  }

  /// Create a subscription
  static RealtimeChannel createSubscription(String table,
      {String? event, String? schema, Map<String, dynamic>? filter}) {
    final channel = client.channel('public:$table');

    // Configure the channel for Postgres changes
    channel.subscribe((status, [error]) {
      if (error != null) {
        // Use logger instead of print
        // Logger.error('Error subscribing to channel: $error');
      }
    });

    return channel;
  }

  /// Subscribe to table changes
  static RealtimeChannel subscribeToTable(
    String table, {
    String? event,
    String? schema,
    Map<String, dynamic>? filter,
    void Function(Map<String, dynamic> payload)? callback,
  }) {
    final channel = client.channel('public:$table');

    // Subscribe to the channel
    channel.subscribe((status, [error]) {
      if (error != null) {
        // Use logger instead of print
        // Logger.error('Error subscribing to channel: $error');
      }
    });

    return channel;
  }

  /// Unsubscribe from table changes
  static Future<void> unsubscribeFromTable(RealtimeChannel channel) async {
    await channel.unsubscribe();
  }
}
