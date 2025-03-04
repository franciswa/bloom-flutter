import 'package:flutter/foundation.dart';

import '../models/profile.dart';
import '../providers/auth_provider.dart';
import '../services/service_registry.dart';

/// Profile provider
class ProfileProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Current profile
  Profile? _currentProfile;

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Creates a new [ProfileProvider] instance
  ProfileProvider({
    required AuthProvider authProvider,
  }) : _authProvider = authProvider {
    _init();
  }

  /// Initialize
  Future<void> _init() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _currentProfile = await ServiceRegistry.profileService.getProfileByUserId(
        _authProvider.currentUser!.id,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update auth provider
  void update({required AuthProvider authProvider}) {
    if (_authProvider.currentUser?.id != authProvider.currentUser?.id) {
      _init();
    }
  }

  /// Get current profile
  Profile? get currentProfile => _currentProfile;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Has profile
  bool get hasProfile => _currentProfile != null;

  /// Is profile complete
  bool get isProfileComplete =>
      _currentProfile != null && _currentProfile!.isProfileComplete;

  /// Create profile
  Future<void> createProfile(Profile profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentProfile = await ServiceRegistry.profileService.createProfile(profile);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile
  Future<void> updateProfile(Profile profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentProfile = await ServiceRegistry.profileService.updateProfile(profile);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete profile
  Future<void> deleteProfile() async {
    if (_currentProfile == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.profileService.deleteProfile(_currentProfile!.userId);
      _currentProfile = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upload profile photo
  Future<void> uploadProfilePhoto({
    required String filePath,
    required String fileName,
  }) async {
    if (_currentProfile == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final photoUrl = await ServiceRegistry.profileService.uploadProfilePhoto(
        userId: _currentProfile!.userId,
        filePath: filePath,
        fileName: fileName,
      );

      final photoUrls = List<String>.from(_currentProfile!.photoUrls);
      photoUrls.add(photoUrl);

      _currentProfile = _currentProfile!.copyWith(photoUrls: photoUrls);
      await ServiceRegistry.profileService.updateProfile(_currentProfile!);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete profile photo
  Future<void> deleteProfilePhoto({
    required String photoUrl,
    required String fileName,
  }) async {
    if (_currentProfile == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.profileService.deleteProfilePhoto(
        userId: _currentProfile!.userId,
        fileName: fileName,
      );

      final photoUrls = List<String>.from(_currentProfile!.photoUrls);
      photoUrls.remove(photoUrl);

      _currentProfile = _currentProfile!.copyWith(photoUrls: photoUrls);
      await ServiceRegistry.profileService.updateProfile(_currentProfile!);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile visibility
  Future<void> updateProfileVisibility({required bool isVisible}) async {
    if (_currentProfile == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.profileService.updateProfileVisibility(
        userId: _currentProfile!.userId,
        isVisible: isVisible,
      );

      _currentProfile = _currentProfile!.copyWith(isProfileVisible: isVisible);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update current location
  Future<void> updateCurrentLocation({
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    if (_currentProfile == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.profileService.updateCurrentLocation(
        userId: _currentProfile!.userId,
        location: location,
        latitude: latitude,
        longitude: longitude,
      );

      _currentProfile = _currentProfile!.copyWith(
        currentLocation: () => location,
        currentLatitude: () => latitude,
        currentLongitude: () => longitude,
      );
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if display name is available
  Future<bool> isDisplayNameAvailable(String displayName) async {
    try {
      return await ServiceRegistry.profileService.isDisplayNameAvailable(displayName);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  /// Get profile by display name
  Future<Profile?> getProfileByDisplayName(String displayName) async {
    try {
      return await ServiceRegistry.profileService.getProfileByDisplayName(displayName);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  /// Get profile by user ID
  Future<Profile?> getProfileByUserId(String userId) async {
    try {
      return await ServiceRegistry.profileService.getProfileByUserId(userId);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  /// Get profiles by IDs
  Future<List<Profile>> getProfilesByIds(List<String> userIds) async {
    try {
      return await ServiceRegistry.profileService.getProfilesByIds(userIds);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  /// Search profiles
  Future<List<Profile>> searchProfiles({
    required Gender gender,
    required LookingFor lookingFor,
    required int minAge,
    required int maxAge,
    required double latitude,
    required double longitude,
    required double maxDistance,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      return await ServiceRegistry.profileService.searchProfiles(
        gender: gender,
        lookingFor: lookingFor,
        minAge: minAge,
        maxAge: maxAge,
        latitude: latitude,
        longitude: longitude,
        maxDistance: maxDistance,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  /// Get nearby profiles
  Future<List<Profile>> getNearbyProfiles({
    required double latitude,
    required double longitude,
    required double maxDistance,
    required Gender gender,
    required LookingFor lookingFor,
    required int minAge,
    required int maxAge,
    int limit = 20,
    int offset = 0,
  }) async {
    if (_currentProfile == null) {
      return [];
    }

    try {
      return await ServiceRegistry.profileService.getNearbyProfiles(
        userId: _currentProfile!.userId,
        latitude: latitude,
        longitude: longitude,
        maxDistance: maxDistance,
        gender: gender,
        lookingFor: lookingFor,
        minAge: minAge,
        maxAge: maxAge,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  /// Get recommended profiles
  Future<List<Profile>> getRecommendedProfiles({
    required Gender gender,
    required LookingFor lookingFor,
    required int minAge,
    required int maxAge,
    int limit = 20,
    int offset = 0,
  }) async {
    if (_currentProfile == null) {
      return [];
    }

    try {
      return await ServiceRegistry.profileService.getRecommendedProfiles(
        userId: _currentProfile!.userId,
        gender: gender,
        lookingFor: lookingFor,
        minAge: minAge,
        maxAge: maxAge,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
