class Validation {
  static List<String> validateSignUpFields(String email, String password) {
    List<String> errors = [];

    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!isValidEmail(email)) {
      errors.add('Invalid email address');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    } else if (password.length < 6) {
      errors.add('Password must be at least 6 characters long');
    }

    return errors;
  }

  static List<String> validateSignInFields(String email, String password) {
    List<String> errors = [];

    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!isValidEmail(email)) {
      errors.add('Invalid email address');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    }

    return errors;
  }

  static bool isValidEmail(String email) {
    // Determine if the email address is valid.
    final emailRegExp = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z\d-]+$');
    return emailRegExp.hasMatch(email);
  }
}
