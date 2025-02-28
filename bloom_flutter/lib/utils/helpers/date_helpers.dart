import 'package:intl/intl.dart';

/// Date helpers
class DateHelpers {
  /// Private constructor to prevent instantiation
  const DateHelpers._();

  /// Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format time
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
  }

  /// Format message time
  static String formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return DateFormat('h:mm a').format(time);
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(time).inDays < 7) {
      return DateFormat('EEEE').format(time); // Day of week
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  /// Format conversation time
  static String formatConversationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  /// Format birth date
  static String formatBirthDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  /// Format birth time
  static String formatBirthTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format age
  static String formatAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return '$age years old';
  }

  /// Format duration
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Format relative time
  static String formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.isNegative) {
      // Future time
      final absDifference = difference.abs();
      if (absDifference.inDays > 0) {
        return 'in ${absDifference.inDays} ${absDifference.inDays == 1 ? 'day' : 'days'}';
      } else if (absDifference.inHours > 0) {
        return 'in ${absDifference.inHours} ${absDifference.inHours == 1 ? 'hour' : 'hours'}';
      } else if (absDifference.inMinutes > 0) {
        return 'in ${absDifference.inMinutes} ${absDifference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'in a moment';
      }
    } else {
      // Past time
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'just now';
      }
    }
  }

  /// Get zodiac sign
  static String getZodiacSign(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return 'Aries';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return 'Taurus';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return 'Gemini';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return 'Cancer';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return 'Leo';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return 'Virgo';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return 'Libra';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    } else {
      return 'Pisces';
    }
  }

  /// Get moon phase
  static String getMoonPhase(DateTime date) {
    // This is a simplified calculation and not astronomically accurate
    final year = date.year;
    final month = date.month;
    final day = date.day;

    // Calculate approximate moon age in days (0-29.53)
    final jd = _julianDate(year, month, day);
    final moonAge = (jd - 2451550.1) % 29.53;

    // Determine moon phase based on age
    if (moonAge < 1.84) {
      return 'New Moon';
    } else if (moonAge < 5.53) {
      return 'Waxing Crescent';
    } else if (moonAge < 9.22) {
      return 'First Quarter';
    } else if (moonAge < 12.91) {
      return 'Waxing Gibbous';
    } else if (moonAge < 16.61) {
      return 'Full Moon';
    } else if (moonAge < 20.30) {
      return 'Waning Gibbous';
    } else if (moonAge < 23.99) {
      return 'Last Quarter';
    } else {
      return 'Waning Crescent';
    }
  }

  /// Calculate Julian date
  static double _julianDate(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = year ~/ 100;
    final b = 2 - a + (a ~/ 4);
    return (365.25 * (year + 4716)).floor() + (30.6001 * (month + 1)).floor() + day + b - 1524.5;
  }
}
