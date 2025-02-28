import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service
class SupabaseService {
  /// Private constructor to prevent instantiation
  const SupabaseService._();

  /// Supabase client
  static SupabaseClient get client => Supabase.instance.client;

  /// Supabase auth
  static GoTrueClient get auth => client.auth;

  /// Supabase storage
  static SupabaseStorageClient get storage => client.storage;

  /// Supabase functions
  static FunctionsClient get functions => client.functions;

  /// Supabase realtime
  static RealtimeClient get realtime => client.realtime;

  /// Create a channel
  static RealtimeChannel channel(String name) => client.channel(name);

  /// Get auth state changes
  static Stream<AuthState> get onAuthStateChange => auth.onAuthStateChange;

  /// Get current user
  static User? get currentUser => auth.currentUser;

  /// Is signed in
  static bool get isSignedIn => currentUser != null;

  /// Get current session
  static Session? get currentSession => auth.currentSession;

  /// Get user ID
  static String? get userId => currentUser?.id;

  /// Get user email
  static String? get userEmail => currentUser?.email;

  /// Get user phone
  static String? get userPhone => currentUser?.phone;

  /// Is email confirmed
  static bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  /// Is phone confirmed
  static bool get isPhoneConfirmed => currentUser?.phoneConfirmedAt != null;

  /// Get last sign in
  static DateTime? get lastSignIn {
    final signInAt = currentUser?.lastSignInAt;
    if (signInAt == null) return null;
    return DateTime.parse(signInAt);
  }

  /// Get created at
  static DateTime? get createdAt {
    final created = currentUser?.createdAt;
    if (created == null) return null;
    return DateTime.parse(created);
  }

  /// Get updated at
  static DateTime? get updatedAt {
    final updated = currentUser?.updatedAt;
    if (updated == null) return null;
    return DateTime.parse(updated);
  }

  /// Get from table
  static dynamic from<T>(String table) => client.from(table);

  /// Get from table with RLS bypass
  static dynamic fromWithRLS<T>(String table) => client.from(table);

  /// Get from storage bucket
  static dynamic fromBucket(String bucket) => storage.from(bucket);

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
