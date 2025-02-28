/// Validators utility class
class Validators {
  /// Private constructor to prevent instantiation
  const Validators._();

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Validate date of birth
  static String? validateDateOfBirth(DateTime? value) {
    if (value == null) {
      return 'Date of birth is required';
    }

    final now = DateTime.now();
    final age = now.year - value.year - 
        (now.month > value.month || 
            (now.month == value.month && now.day >= value.day) ? 0 : 1);

    if (age < 18) {
      return 'You must be at least 18 years old';
    }

    if (age > 120) {
      return 'Please enter a valid date of birth';
    }

    return null;
  }

  /// Validate time of birth
  static String? validateTimeOfBirth(String? value) {
    if (value == null) {
      return 'Time of birth is required';
    }

    return null;
  }

  /// Validate place of birth
  static String? validatePlaceOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Place of birth is required';
    }

    return null;
  }

  /// Validate bio
  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Bio is optional
    }

    if (value.length > 500) {
      return 'Bio must be less than 500 characters';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }

    // Regular expression for phone number validation
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    // Regular expression for URL validation
    final urlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate number
  static String? validateNumber(String? value, {
    double? min,
    double? max,
    bool allowDecimal = true,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return null; // Number is optional
    }

    // Regular expression for number validation
    final numberRegex = allowDecimal
        ? RegExp(r'^-?\d*\.?\d+$')
        : RegExp(r'^-?\d+$');

    if (!numberRegex.hasMatch(value)) {
      return 'Please enter a valid ${allowDecimal ? 'number' : 'integer'}';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (min != null && number < min) {
      return '${fieldName ?? 'Number'} must be at least $min';
    }

    if (max != null && number > max) {
      return '${fieldName ?? 'Number'} must be at most $max';
    }

    return null;
  }

  /// Validate integer
  static String? validateInteger(String? value, {
    int? min,
    int? max,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return null; // Integer is optional
    }

    // Regular expression for integer validation
    final integerRegex = RegExp(r'^-?\d+$');

    if (!integerRegex.hasMatch(value)) {
      return 'Please enter a valid integer';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid integer';
    }

    if (min != null && number < min) {
      return '${fieldName ?? 'Number'} must be at least $min';
    }

    if (max != null && number > max) {
      return '${fieldName ?? 'Number'} must be at most $max';
    }

    return null;
  }
}
