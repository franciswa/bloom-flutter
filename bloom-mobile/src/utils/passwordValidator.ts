export interface PasswordValidationResult {
  isValid: boolean;
  error?: string;
  strength?: 'weak' | 'medium' | 'strong';
}

/**
 * Validates password strength with multiple requirements
 * @param password The password to validate
 * @returns Object with validation result, error message if invalid, and strength rating
 */
export function validatePassword(password: string): PasswordValidationResult {
  // Check for minimum length
  if (password.length < 8) {
    return {
      isValid: false,
      error: 'Password must be at least 8 characters long',
      strength: 'weak'
    };
  }

  // Check for uppercase letters
  if (!/[A-Z]/.test(password)) {
    return {
      isValid: false,
      error: 'Password must contain at least one uppercase letter',
      strength: 'weak'
    };
  }

  // Check for lowercase letters
  if (!/[a-z]/.test(password)) {
    return {
      isValid: false,
      error: 'Password must contain at least one lowercase letter',
      strength: 'weak'
    };
  }

  // Check for numbers
  if (!/[0-9]/.test(password)) {
    return {
      isValid: false,
      error: 'Password must contain at least one number',
      strength: 'weak'
    };
  }

  // Check for special characters
  if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
    return {
      isValid: false,
      error: 'Password must contain at least one special character',
      strength: 'medium'
    };
  }

  // Determine strength based on length and complexity
  let strength: 'weak' | 'medium' | 'strong' = 'medium';
  
  // If password is longer than 12 chars and has good complexity, it's strong
  if (password.length >= 12 && 
      /[A-Z]/.test(password) && 
      /[a-z]/.test(password) && 
      /[0-9]/.test(password) && 
      /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
    strength = 'strong';
  }

  return {
    isValid: true,
    strength
  };
}

/**
 * Returns a color based on password strength
 * @param strength The password strength
 * @returns Color code for UI indication
 */
export function getPasswordStrengthColor(strength?: 'weak' | 'medium' | 'strong'): string {
  switch (strength) {
    case 'weak':
      return '$red9';
    case 'medium':
      return '$orange9';
    case 'strong':
      return '$green9';
    default:
      return '$gray9';
  }
}