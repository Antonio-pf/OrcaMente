/// Static validation methods for common input validation
class Validators {
  Validators._(); // Private constructor to prevent instantiation

  /// Validates email format
  /// Returns true if email matches standard email pattern
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  /// Validates password strength
  /// Password must have:
  /// - At least 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  /// - At least one special character
  static bool isValidPassword(String password) {
    if (password.isEmpty || password.length < 8) return false;
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }

  /// Validates if two passwords match
  static bool passwordsMatch(String password, String confirmPassword) {
    return password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }

  /// Validates phone number format (Brazilian format)
  /// Accepts formats: (11) 98765-4321, 11987654321, etc.
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    // Remove non-numeric characters
    final numericPhone = phone.replaceAll(RegExp(r'\D'), '');
    // Brazilian phone: 10 digits (with area code) or 11 digits (with area code + 9)
    return numericPhone.length == 10 || numericPhone.length == 11;
  }

  /// Validates name (not empty and at least 2 characters)
  static bool isValidName(String name) {
    final trimmed = name.trim();
    return trimmed.isNotEmpty && trimmed.length >= 2;
  }

  /// Validates if string is not empty after trimming
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validates currency amount (positive number)
  static bool isValidAmount(double amount) {
    return amount > 0 && amount.isFinite;
  }

  /// Validates currency string input
  /// Accepts formats: 1234.56, 1234,56, R$ 1.234,56
  static bool isValidCurrencyString(String value) {
    if (value.isEmpty) return false;
    // Remove currency symbols and spaces
    final cleaned = value
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    final parsed = double.tryParse(cleaned);
    return parsed != null && parsed > 0;
  }

  /// Parses currency string to double
  /// Returns null if invalid
  static double? parseCurrency(String value) {
    if (!isValidCurrencyString(value)) return null;
    final cleaned = value
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  /// Validates expense description length
  static bool isValidDescription(String description, {int maxLength = 200}) {
    final trimmed = description.trim();
    return trimmed.isNotEmpty && trimmed.length <= maxLength;
  }

  /// Validates expense category (not empty)
  static bool isValidCategory(String category) {
    return category.trim().isNotEmpty;
  }

  /// Validates goal amount for piggy bank (positive and greater than zero)
  static bool isValidGoal(double goal) {
    return goal > 0 && goal.isFinite;
  }

  /// Returns error message for email validation
  static String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Email é obrigatório.';
    }
    if (!isValidEmail(email)) {
      return 'Formato de e-mail inválido.';
    }
    return null;
  }

  /// Returns error message for password validation
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória.';
    }
    if (password.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres.';
    }
    if (!isValidPassword(password)) {
      return 'Senha deve conter letras maiúsculas, minúsculas, números e caracteres especiais.';
    }
    return null;
  }

  /// Returns error message for password confirmation
  static String? validatePasswordConfirmation(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return 'Confirmação de senha é obrigatória.';
    }
    if (!passwordsMatch(password, confirmPassword)) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  /// Returns error message for name validation
  static String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Nome é obrigatório.';
    }
    if (!isValidName(name)) {
      return 'Nome deve ter no mínimo 2 caracteres.';
    }
    return null;
  }

  /// Returns error message for phone validation
  static String? validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return 'Telefone é obrigatório.';
    }
    if (!isValidPhone(phone)) {
      return 'Formato de telefone inválido.';
    }
    return null;
  }

  /// Returns error message for amount validation
  static String? validateAmount(String amountStr) {
    if (amountStr.trim().isEmpty) {
      return 'Valor é obrigatório.';
    }
    final amount = parseCurrency(amountStr);
    if (amount == null || !isValidAmount(amount)) {
      return 'Valor inválido. Digite um número positivo.';
    }
    return null;
  }

  /// Returns error message for description validation
  static String? validateDescription(
    String description, {
    int maxLength = 200,
  }) {
    if (description.trim().isEmpty) {
      return 'Descrição é obrigatória.';
    }
    if (description.trim().length > maxLength) {
      return 'Descrição deve ter no máximo $maxLength caracteres.';
    }
    return null;
  }
}
