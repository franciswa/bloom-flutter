import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/error_handling.dart';

/// Cache service
class CacheService {
  /// Cache box
  static late Box _cacheBox;

  /// Cache expiration box
  static late Box _expirationBox;

  /// Default expiration duration in seconds (1 hour)
  static const int defaultExpirationSeconds = 3600;

  /// Initialize cache service
  static Future<void> initialize() async {
    try {
      if (kIsWeb) {
        // For web platform, initialize Hive without a specific path
        await Hive.initFlutter();
      } else {
        // For mobile platforms, use the app document directory
        final appDocumentDir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(appDocumentDir.path);
      }

      _cacheBox = await Hive.openBox('cache');
      _expirationBox = await Hive.openBox('cache_expiration');

      if (kDebugMode) {
        print('Cache service initialized successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Failed to initialize cache service: $e');
      }
      ErrorHandler.logError(e,
          stackTrace: stackTrace, hint: 'Cache initialization failed');

      // Create fallback in-memory boxes for web
      if (kIsWeb) {
        try {
          _cacheBox = await Hive.openBox('cache', bytes: Uint8List(0));
          _expirationBox =
              await Hive.openBox('cache_expiration', bytes: Uint8List(0));
          if (kDebugMode) {
            print('Created fallback in-memory cache for web');
          }
        } catch (fallbackError) {
          if (kDebugMode) {
            print('Failed to create fallback cache: $fallbackError');
          }
          // If even the fallback fails, create dummy boxes that do nothing
          _createDummyBoxes();
        }
      } else {
        // For non-web platforms, create dummy boxes that do nothing
        _createDummyBoxes();
      }
    }
  }

  /// Create dummy boxes that do nothing (for fallback)
  static void _createDummyBoxes() {
    // Create dummy box implementations that don't throw errors but don't do anything
    _cacheBox = _DummyBox();
    _expirationBox = _DummyBox();
    if (kDebugMode) {
      print('Using dummy cache boxes as fallback');
    }
  }

  /// Set cache
  static Future<void> set({
    required String key,
    required dynamic value,
    int expirationSeconds = defaultExpirationSeconds,
  }) async {
    // Calculate expiration time
    final expirationTime = DateTime.now()
        .add(Duration(seconds: expirationSeconds))
        .millisecondsSinceEpoch;

    // Store value and expiration time
    await _cacheBox.put(key, _encodeValue(value));
    await _expirationBox.put(key, expirationTime);
  }

  /// Get cache
  static T? get<T>({
    required String key,
    bool checkExpiration = true,
  }) {
    // Check if key exists
    if (!_cacheBox.containsKey(key)) {
      return null;
    }

    // Check expiration
    if (checkExpiration) {
      final expirationTime = _expirationBox.get(key) as int?;
      if (expirationTime == null ||
          expirationTime < DateTime.now().millisecondsSinceEpoch) {
        // Cache expired, remove it
        _cacheBox.delete(key);
        _expirationBox.delete(key);
        return null;
      }
    }

    // Return value
    return _decodeValue<T>(_cacheBox.get(key));
  }

  /// Remove cache
  static Future<void> remove(String key) async {
    await _cacheBox.delete(key);
    await _expirationBox.delete(key);
  }

  /// Clear all cache
  static Future<void> clear() async {
    await _cacheBox.clear();
    await _expirationBox.clear();
  }

  /// Check if cache exists
  static bool exists(String key) {
    return _cacheBox.containsKey(key);
  }

  /// Refresh cache expiration
  static Future<void> refreshExpiration({
    required String key,
    int expirationSeconds = defaultExpirationSeconds,
  }) async {
    if (_cacheBox.containsKey(key)) {
      final expirationTime = DateTime.now()
          .add(Duration(seconds: expirationSeconds))
          .millisecondsSinceEpoch;
      await _expirationBox.put(key, expirationTime);
    }
  }

  /// Get all keys
  static List<String> getAllKeys() {
    return _cacheBox.keys.cast<String>().toList();
  }

  /// Get cache size
  static int getCacheSize() {
    return _cacheBox.length;
  }

  /// Encode value
  static String _encodeValue(dynamic value) {
    if (value is String) {
      return value;
    } else {
      return jsonEncode(value);
    }
  }

  /// Decode value
  static T? _decodeValue<T>(String value) {
    if (T == String) {
      return value as T;
    }

    try {
      final decoded = jsonDecode(value);

      if (decoded is T) {
        return decoded;
      } else if (T == List<dynamic>) {
        return decoded as T;
      } else if (T == Map<String, dynamic>) {
        return decoded as T;
      } else {
        return null;
      }
    } catch (e) {
      ErrorHandler.logError(e, hint: 'Error decoding cache value');
      return null;
    }
  }
}

/// Dummy box implementation for fallback when Hive initialization fails
class _DummyBox implements Box {
  @override
  dynamic get(dynamic key, {dynamic defaultValue}) => defaultValue;

  @override
  Future<void> put(dynamic key, dynamic value) async {}

  @override
  Future<void> delete(dynamic key) async {}

  @override
  Future<int> clear() async => 0;

  @override
  bool containsKey(dynamic key) => false;

  @override
  Iterable get keys => [];

  @override
  int get length => 0;

  @override
  String get name => 'dummy_box';

  @override
  bool get isOpen => true;

  @override
  Future<void> close() async {}

  @override
  Future<int> add(value) async => 0;

  @override
  Future<Iterable<int>> addAll(Iterable values) async => [];

  @override
  Future<void> compact() async {}

  @override
  Future<void> deleteAll(Iterable keys) async {}

  @override
  Future<void> deleteAt(int index) async {}

  @override
  Future<void> deleteFromDisk() async {}

  @override
  Future<void> flush() async {}

  @override
  dynamic getAt(int index) => null;

  @override
  bool get isEmpty => true;

  @override
  bool get isNotEmpty => false;

  @override
  Iterable<dynamic> get values => [];

  @override
  dynamic keyAt(int index) => null;

  @override
  Future<int> putAll(Map entries) async => 0;

  @override
  Future<void> putAt(int index, value) async {}

  @override
  Future<void> putFirst(key, value) async {}

  @override
  Stream<BoxEvent> watch({dynamic key}) => Stream.empty();

  @override
  Iterable valuesBetween({startKey, endKey}) => [];

  @override
  Map toMap() => {};

  @override
  bool get lazy => false;

  @override
  String get path => '';
}

/// Cache manager
class CacheManager<T> {
  /// Cache key prefix
  final String keyPrefix;

  /// Expiration duration in seconds
  final int expirationSeconds;

  /// Fetch data function
  final Future<T> Function() fetchData;

  /// To JSON function
  final Map<String, dynamic> Function(T data) toJson;

  /// From JSON function
  final T Function(Map<String, dynamic> json) fromJson;

  /// Creates a new [CacheManager] instance
  CacheManager({
    required this.keyPrefix,
    this.expirationSeconds = CacheService.defaultExpirationSeconds,
    required this.fetchData,
    required this.toJson,
    required this.fromJson,
  });

  /// Get data
  Future<T> getData({bool forceRefresh = false}) async {
    final cacheKey = keyPrefix;

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = CacheService.get<Map<String, dynamic>>(key: cacheKey);
      if (cachedData != null) {
        return fromJson(cachedData);
      }
    }

    // Fetch fresh data
    final data = await fetchData();

    // Cache data
    await CacheService.set(
      key: cacheKey,
      value: toJson(data),
      expirationSeconds: expirationSeconds,
    );

    return data;
  }

  /// Invalidate cache
  Future<void> invalidateCache() async {
    await CacheService.remove(keyPrefix);
  }
}
