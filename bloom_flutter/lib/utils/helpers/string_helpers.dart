import 'dart:math';

/// String helpers
class StringHelpers {
  /// Private constructor to prevent instantiation
  const StringHelpers._();

  /// Capitalize first letter
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalize each word
  static String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalizeFirstLetter(word)).join(' ');
  }

  /// Truncate text
  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Get initials
  static String getInitials(String name, {int maxInitials = 2}) {
    if (name.isEmpty) return '';
    
    final parts = name.trim().split(' ');
    final initials = parts.map((part) => part.isNotEmpty ? part[0].toUpperCase() : '').join('');
    
    return initials.substring(0, min(initials.length, maxInitials));
  }

  /// Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    // Format based on length
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly[0] == '1') {
      return '${digitsOnly[0]} (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    }
    
    // Return original if not a standard format
    return phoneNumber;
  }

  /// Format currency
  static String formatCurrency(double amount, {String symbol = '\$', int decimalPlaces = 2}) {
    return '$symbol${amount.toStringAsFixed(decimalPlaces)}';
  }

  /// Format number with commas
  static String formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Remove HTML tags
  static String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Is valid email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Is valid URL
  static bool isValidUrl(String url) {
    final urlRegex = RegExp(
      r'^(http|https)://[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}(/\S*)?$',
    );
    return urlRegex.hasMatch(url);
  }

  /// Is valid phone number
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(
      r'^\+?[0-9]{10,15}$',
    );
    return phoneRegex.hasMatch(phoneNumber.replaceAll(RegExp(r'\D'), ''));
  }

  /// Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Extract URLs from text
  static List<String> extractUrls(String text) {
    final urlRegex = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );
    return urlRegex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  /// Extract hashtags from text
  static List<String> extractHashtags(String text) {
    final hashtagRegex = RegExp(r'#(\w+)');
    return hashtagRegex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  /// Extract mentions from text
  static List<String> extractMentions(String text) {
    final mentionRegex = RegExp(r'@(\w+)');
    return mentionRegex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  /// Count words
  static int countWords(String text) {
    if (text.isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  /// Count characters
  static int countCharacters(String text, {bool includeSpaces = true}) {
    if (!includeSpaces) {
      return text.replaceAll(RegExp(r'\s'), '').length;
    }
    return text.length;
  }

  /// Get reading time in minutes
  static int getReadingTimeInMinutes(String text, {int wordsPerMinute = 200}) {
    final wordCount = countWords(text);
    return (wordCount / wordsPerMinute).ceil();
  }

  /// Slugify
  static String slugify(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  /// Mask sensitive data
  static String maskSensitiveData(String text, {int visibleChars = 4, String mask = '*'}) {
    if (text.length <= visibleChars) return text;
    
    final visiblePart = text.substring(text.length - visibleChars);
    final maskedPart = mask * (text.length - visibleChars);
    
    return maskedPart + visiblePart;
  }

  /// Format message preview
  static String formatMessagePreview(String message, {int maxLength = 50}) {
    // Remove new lines and extra spaces
    final cleanedMessage = message.replaceAll(RegExp(r'\s+'), ' ').trim();
    return truncateText(cleanedMessage, maxLength);
  }
}
