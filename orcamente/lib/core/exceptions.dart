/// Base exception class for application errors
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalError});

  /// Invalid credentials (wrong email/password)
  factory AuthException.invalidCredentials() => const AuthException(
    'E-mail ou senha incorretos. Verifique suas credenciais.',
    code: 'invalid-credential',
  );

  /// User not found
  factory AuthException.userNotFound() => const AuthException(
    'Usuário não encontrado. Verifique o e-mail digitado.',
    code: 'user-not-found',
  );

  /// Email already in use
  factory AuthException.emailAlreadyInUse() => const AuthException(
    'Este e-mail já está sendo usado.',
    code: 'email-already-in-use',
  );

  /// Weak password
  factory AuthException.weakPassword() => const AuthException(
    'Senha muito fraca. Use ao menos 8 caracteres com letras maiúsculas, minúsculas, números e caracteres especiais.',
    code: 'weak-password',
  );

  /// Invalid email format
  factory AuthException.invalidEmail() =>
      const AuthException('Formato de e-mail inválido.', code: 'invalid-email');

  /// User disabled
  factory AuthException.userDisabled() =>
      const AuthException('A conta foi desativada.', code: 'user-disabled');

  /// Too many requests
  factory AuthException.tooManyRequests() => const AuthException(
    'Muitas tentativas. Tente novamente mais tarde.',
    code: 'too-many-requests',
  );

  /// Operation not allowed
  factory AuthException.operationNotAllowed() => const AuthException(
    'Operação não permitida.',
    code: 'operation-not-allowed',
  );
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});

  /// No internet connection
  factory NetworkException.noConnection() => const NetworkException(
    'Sem conexão com a internet. Verifique sua rede.',
    code: 'no-connection',
  );

  /// Request timeout
  factory NetworkException.timeout() => const NetworkException(
    'A operação demorou muito. Tente novamente.',
    code: 'timeout',
  );

  /// Network request failed
  factory NetworkException.requestFailed() => const NetworkException(
    'Erro de conexão. Verifique sua internet.',
    code: 'network-request-failed',
  );
}

/// Data/Firestore-related exceptions
class DataException extends AppException {
  const DataException(super.message, {super.code, super.originalError});

  /// Document not found
  factory DataException.notFound() =>
      const DataException('Dados não encontrados.', code: 'not-found');

  /// Permission denied
  factory DataException.permissionDenied() => const DataException(
    'Você não tem permissão para acessar estes dados.',
    code: 'permission-denied',
  );

  /// Invalid data format
  factory DataException.invalidFormat() =>
      const DataException('Formato de dados inválido.', code: 'invalid-format');

  /// Data already exists
  factory DataException.alreadyExists() =>
      const DataException('Dados já existem.', code: 'already-exists');

  /// Failed to save data
  factory DataException.saveFailed() => const DataException(
    'Falha ao salvar dados. Tente novamente.',
    code: 'save-failed',
  );

  /// Failed to delete data
  factory DataException.deleteFailed() => const DataException(
    'Falha ao deletar dados. Tente novamente.',
    code: 'delete-failed',
  );

  /// Failed to load data
  factory DataException.loadFailed() => const DataException(
    'Falha ao carregar dados. Tente novamente.',
    code: 'load-failed',
  );
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.originalError});

  /// Required field is empty
  factory ValidationException.requiredField(String fieldName) =>
      ValidationException(
        'O campo "$fieldName" é obrigatório.',
        code: 'required-field',
      );

  /// Invalid field format
  factory ValidationException.invalidFormat(String fieldName) =>
      ValidationException(
        'O campo "$fieldName" está em formato inválido.',
        code: 'invalid-format',
      );

  /// Field value too short
  factory ValidationException.tooShort(String fieldName, int minLength) =>
      ValidationException(
        'O campo "$fieldName" deve ter no mínimo $minLength caracteres.',
        code: 'too-short',
      );

  /// Field value too long
  factory ValidationException.tooLong(String fieldName, int maxLength) =>
      ValidationException(
        'O campo "$fieldName" deve ter no máximo $maxLength caracteres.',
        code: 'too-long',
      );

  /// Values don't match
  factory ValidationException.mismatch(String field1, String field2) =>
      ValidationException(
        'Os campos "$field1" e "$field2" não coincidem.',
        code: 'mismatch',
      );
}
