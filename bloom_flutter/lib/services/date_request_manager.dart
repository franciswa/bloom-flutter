import 'package:flutter/foundation.dart';

import '../models/date_preference.dart';
import '../providers/date_preference_provider.dart';
import '../providers/message_provider.dart';

/// Maximum number of combined date requests and conversations allowed
const int maxCombinedRequestsAndConversations = 3;

/// Date request manager
class DateRequestManager {
  /// Message provider
  final MessageProvider _messageProvider;

  /// Date preference provider
  final DatePreferenceProvider _datePreferenceProvider;

  /// Creates a new [DateRequestManager] instance
  DateRequestManager({
    required MessageProvider messageProvider,
    required DatePreferenceProvider datePreferenceProvider,
  })  : _messageProvider = messageProvider,
        _datePreferenceProvider = datePreferenceProvider;

  /// Get active date requests count
  int getActiveDateRequestsCount() {
    // Count date suggestions with pending or scheduled status
    return _datePreferenceProvider.dateSuggestions
        .where((suggestion) =>
            suggestion.status == DateSuggestionStatus.pending ||
            suggestion.status == DateSuggestionStatus.scheduled)
        .length;
  }

  /// Get active conversations count
  int getActiveConversationsCount() {
    // Count all active conversations
    return _messageProvider.conversations.length;
  }

  /// Get combined count of active date requests and conversations
  int getCombinedCount() {
    return getActiveDateRequestsCount() + getActiveConversationsCount();
  }

  /// Check if user can send more date requests
  bool canSendMoreDateRequests() {
    return getCombinedCount() < maxCombinedRequestsAndConversations;
  }

  /// Get remaining date requests
  int getRemainingDateRequests() {
    return maxCombinedRequestsAndConversations - getCombinedCount();
  }

  /// Check if user has reached the limit
  bool hasReachedLimit() {
    return getCombinedCount() >= maxCombinedRequestsAndConversations;
  }
}

/// Date request manager provider
class DateRequestManagerProvider extends ChangeNotifier {
  /// Date request manager
  final DateRequestManager _dateRequestManager;

  /// Creates a new [DateRequestManagerProvider] instance
  DateRequestManagerProvider({
    required MessageProvider messageProvider,
    required DatePreferenceProvider datePreferenceProvider,
  }) : _dateRequestManager = DateRequestManager(
          messageProvider: messageProvider,
          datePreferenceProvider: datePreferenceProvider,
        );

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

  /// Notify listeners
  void notifyChanges() {
    notifyListeners();
  }
}
