class FormValidators {
  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  // Login identifier: non-empty and at least five characters.
  static String? loginIdentifier(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Please enter your Academic ID or Email';
    }

    if (input.length < 5) {
      return 'Must contain at least 5 characters';
    }

    return null;
  }

  // Login password: at least six characters.
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Full name: at least three trimmed characters.
  static String? fullName(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Please enter your full name';
    }

    if (input.length < 3) {
      return 'Name must contain at least 3 characters';
    }

    return null;
  }

  // Academic ID: ASCII digits only, exactly 9 or 10 digits.
  static String? academicId(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Please enter your Academic ID';
    }

    if (!RegExp(r'^[0-9]{9,10}$').hasMatch(input)) {
      return 'Academic ID must contain 9 or 10 digits';
    }

    return null;
  }

  // Standard email syntax. No fixed university domain was specified.
  static String? universityEmail(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Please enter your university email';
    }

    if (!_emailRegex.hasMatch(input)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // At least 8 characters, one uppercase English letter, and one digit.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Forgot password accepts a valid email or a 9-10 digit Academic ID.
  static String? resetIdentifier(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Please enter your email or Academic ID';
    }

    final isEmail = _emailRegex.hasMatch(input);
    final isAcademicId = RegExp(r'^[0-9]{9,10}$').hasMatch(input);

    if (!isEmail && !isAcademicId) {
      return 'Enter a valid email or Academic ID';
    }

    return null;
  }

  // OTP: exactly six ASCII digits.
  static String? otp(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Please enter the verification code';
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(input)) {
      return 'OTP must contain exactly 6 digits';
    }

    return null;
  }

  static String? termsAccepted(bool? value) {
    if (value != true) {
      return 'You must accept the academic terms';
    }

    return null;
  }
}
