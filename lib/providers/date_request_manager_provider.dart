import 'package:flutter/foundation.dart';

import '../services/date_request_manager.dart';
import 'date_preference_provider.dart';
import 'message_provider.dart';

/// Date request manager provider
class DateRequestManagerProvider extends ChangeNotifier {
  /// Date request manager
  final DateRequestManager _dateRequestManager;

  /// Message provider
  final MessageProvider _messageProvider;

  /// Date preference provider
  final DatePreferenceProvider _datePreferenceProvider;

  /// Creates a new [DateRequestManagerProvider] instance
  DateRequestManagerProvider({
    required MessageProvider messageProvider,
    required DatePreferenceProvider datePreferenceProvider,
  })  : _messageProvider = messageProvider,
        _datePreferenceProvider = datePreferenceProvider,
        _dateRequestManager = DateRequestManager(
          messageProvider: messageProvider,
          datePreferenceProvider: datePreferenceProvider,
        ) {
    // Listen to changes in message provider
    _messageProvider.addListener(_onProvidersChanged);

    // Listen to changes in date preference provider
    _datePreferenceProvider.addListener(_onProvidersChanged);
  }

  /// On providers changed
  void _onProvidersChanged() {
    notifyListeners();
  }

  /// Get date request manager
  DateRequestManager get dateRequestManager => _dateRequestManager;

  /// Check if user can send more date requests
  bool canSendMoreDateRequests() {
    return _dateRequestManager.canSendMoreDateRequests();
  }

  /// Get remaining date requests
  int getRemainingDateRequests() {
    return _dateRequestManager.getRemainingDateRequests();
  }

  /// Check if user has reached the limit
  bool hasReachedLimit() {
    return _dateRequestManager.hasReachedLimit();
  }

  /// Get combined count of active date requests and conversations
  int getCombinedCount() {
    return _dateRequestManager.getCombinedCount();
  }

  /// Update message provider
  void updateMessageProvider({required MessageProvider messageProvider}) {
    if (_messageProvider != messageProvider) {
      _messageProvider.removeListener(_onProvidersChanged);
      messageProvider.addListener(_onProvidersChanged);
      notifyListeners();
    }
  }

  /// Update date preference provider
  void updateDatePreferenceProvider({
    required DatePreferenceProvider datePreferenceProvider,
  }) {
    if (_datePreferenceProvider != datePreferenceProvider) {
      _datePreferenceProvider.removeListener(_onProvidersChanged);
      datePreferenceProvider.addListener(_onProvidersChanged);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _messageProvider.removeListener(_onProvidersChanged);
    _datePreferenceProvider.removeListener(_onProvidersChanged);
    super.dispose();
  }
}
