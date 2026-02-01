/// Core application constants
/// All app-wide constants should be defined here
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ============================================================================
  // VALIDATION CONSTANTS
  // ============================================================================

  /// Minimum password length required for authentication
  static const int minPasswordLength = 6;

  /// Maximum password length allowed
  static const int maxPasswordLength = 128;

  /// Minimum name length for user registration
  static const int minNameLength = 2;

  /// Maximum name length for user registration
  static const int maxNameLength = 100;

  /// Maximum expense description length
  static const int maxExpenseDescriptionLength = 200;

  /// Minimum expense value
  static const double minExpenseValue = 0.01;

  /// Maximum expense value
  static const double maxExpenseValue = 999999.99;

  // ============================================================================
  // FIREBASE CONSTANTS
  // ============================================================================

  /// Users collection name in Firestore
  static const String usersCollection = 'users';

  /// Expenses collection name in Firestore
  static const String expensesCollection = 'expenses';

  /// PiggyBank collection name in Firestore
  static const String piggyBankCollection = 'piggyBank';

  /// Quiz answers subcollection name
  static const String quizAnswersCollection = 'quizAnswers';

  /// Transactions subcollection name
  static const String transactionsCollection = 'transactions';

  // ============================================================================
  // FIRESTORE FIELD NAMES
  // ============================================================================

  /// User document fields
  static const String fieldUserId = 'userId';
  static const String fieldUserName = 'nome';
  static const String fieldUserEmail = 'email';
  static const String fieldUserPhone = 'telefone';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  /// Expense document fields
  static const String fieldExpenseId = 'id';
  static const String fieldExpenseDescription = 'description';
  static const String fieldExpenseValue = 'value';
  static const String fieldExpenseCategory = 'category';
  static const String fieldExpenseDate = 'date';

  /// PiggyBank document fields
  static const String fieldPiggyBankCurrentAmount = 'currentAmount';
  static const String fieldPiggyBankGoalAmount = 'goalAmount';
  static const String fieldPiggyBankGoalDate = 'goalDate';
  static const String fieldPiggyBankName = 'name';

  // ============================================================================
  // EXPENSE CATEGORIES
  // ============================================================================

  /// Valid expense categories
  static const List<String> expenseCategories = [
    'essencial',
    'lazer',
    'outros',
  ];

  /// Expense category labels (Portuguese)
  static const Map<String, String> expenseCategoryLabels = {
    'essencial': 'Essenciais',
    'lazer': 'Lazer',
    'outros': 'Outros',
  };

  // ============================================================================
  // UI/UX CONSTANTS
  // ============================================================================

  /// Default border radius for cards and containers
  static const double defaultBorderRadius = 12.0;

  /// Default padding for containers
  static const double defaultPadding = 16.0;

  /// Default spacing between elements
  static const double defaultSpacing = 8.0;

  /// Default animation duration in milliseconds
  static const int defaultAnimationDurationMs = 300;

  /// Default snackbar duration in seconds
  static const int defaultSnackbarDurationSeconds = 3;

  // ============================================================================
  // NETWORK CONSTANTS
  // ============================================================================

  /// Network request timeout in seconds
  static const int networkTimeoutSeconds = 30;

  /// Retry delay in seconds for failed requests
  static const int retryDelaySeconds = 2;

  /// Maximum number of retry attempts
  static const int maxRetryAttempts = 3;

  // ============================================================================
  // STORAGE KEYS (SharedPreferences)
  // ============================================================================

  /// Key for storing theme preference
  static const String keyThemeMode = 'theme_mode';

  /// Key for storing user ID (deprecated - use Firebase Auth)
  @Deprecated('Use Firebase Auth instead')
  static const String keyUserId = 'user_id';

  /// Legacy piggy bank storage keys (for migration only)
  static const String keyPiggyBankValue = 'piggyBankValue';
  static const String keyPiggyBankGoal = 'piggyBankGoal';
  static const String keyPiggyBankDate = 'piggyBankDate';

  // ============================================================================
  // BUSINESS LOGIC CONSTANTS
  // ============================================================================

  /// Default piggy bank goal amount
  static const double defaultPiggyBankGoal = 1000.0;

  /// Minimum piggy bank goal
  static const double minPiggyBankGoal = 1.0;

  /// Maximum piggy bank goal
  static const double maxPiggyBankGoal = 999999.99;

  /// Number of months to keep expense history
  static const int expenseHistoryMonths = 12;

  // ============================================================================
  // DATE/TIME CONSTANTS
  // ============================================================================

  /// Date format for display (dd/MM/yyyy)
  static const String dateFormat = 'dd/MM/yyyy';

  /// Date format for display with time (dd/MM/yyyy HH:mm)
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  /// Date format for API (yyyy-MM-dd)
  static const String apiDateFormat = 'yyyy-MM-dd';

  // ============================================================================
  // REGEX PATTERNS
  // ============================================================================

  /// Email validation regex pattern
  static const String emailRegexPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  /// Phone validation regex pattern (Brazilian format)
  static const String phoneRegexPattern =
      r'^\([1-9]{2}\) (?:[2-8]|9[0-9])[0-9]{3}\-[0-9]{4}$';

  /// Currency validation regex pattern
  static const String currencyRegexPattern = r'^\d+([.,]\d{1,2})?$';

  // ============================================================================
  // ERROR CODES
  // ============================================================================

  /// Authentication error codes
  static const String errorCodeInvalidCredential = 'invalid-credential';
  static const String errorCodeUserNotFound = 'user-not-found';
  static const String errorCodeWrongPassword = 'wrong-password';
  static const String errorCodeEmailAlreadyInUse = 'email-already-in-use';
  static const String errorCodeWeakPassword = 'weak-password';
  static const String errorCodeNetworkRequestFailed = 'network-request-failed';

  /// Firestore error codes
  static const String errorCodePermissionDenied = 'permission-denied';
  static const String errorCodeNotFound = 'not-found';
  static const String errorCodeAlreadyExists = 'already-exists';
  static const String errorCodeUnavailable = 'unavailable';

  // ============================================================================
  // APP METADATA
  // ============================================================================

  /// App name
  static const String appName = 'OrçaMente';

  /// App version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';

  /// Minimum supported app version
  static const String minSupportedVersion = '1.0.0';

  /// Terms of service URL
  static const String termsOfServiceUrl = 'https://orcamente.com/terms';

  /// Privacy policy URL
  static const String privacyPolicyUrl = 'https://orcamente.com/privacy';

  /// Support email
  static const String supportEmail = 'suporte@orcamente.com';
}
