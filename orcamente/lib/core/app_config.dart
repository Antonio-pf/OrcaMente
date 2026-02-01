import 'package:flutter/foundation.dart';

/// Application configuration based on environment
/// Manages app-wide settings, feature flags, and environment-specific behavior
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // ============================================================================
  // ENVIRONMENT DETECTION
  // ============================================================================

  /// Returns true if running in debug mode
  static bool get isDebug => kDebugMode;

  /// Returns true if running in release mode
  static bool get isRelease => kReleaseMode;

  /// Returns true if running in profile mode
  static bool get isProfile => kProfileMode;

  /// Returns current environment name
  static String get environment {
    if (isDebug) return 'development';
    if (isProfile) return 'staging';
    return 'production';
  }

  // ============================================================================
  // LOGGING CONFIGURATION
  // ============================================================================

  /// Enable logging in debug mode only
  static bool get enableLogging => isDebug;

  /// Enable verbose logging (includes debug prints)
  static bool get enableVerboseLogging => isDebug;

  /// Enable error logging to external service (e.g., Sentry, Firebase Crashlytics)
  static bool get enableErrorReporting => isRelease;

  /// Enable analytics tracking
  static bool get enableAnalytics => isRelease;

  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================

  /// Enable experimental features (debug only)
  static bool get enableExperimentalFeatures => isDebug;

  /// Enable offline mode
  static bool get enableOfflineMode => true;

  /// Enable biometric authentication
  static bool get enableBiometricAuth => false; // TODO: Implement in future

  /// Enable social login (Google, Apple)
  static bool get enableSocialLogin => false; // TODO: Implement in future

  /// Enable data export (CSV, PDF)
  static bool get enableDataExport => false; // TODO: Implement in future

  /// Enable recurring expenses
  static bool get enableRecurringExpenses => false; // TODO: Implement in future

  /// Enable budget planning
  static bool get enableBudgetPlanning => false; // TODO: Implement in future

  /// Enable multi-currency support
  static bool get enableMultiCurrency => false; // TODO: Implement in future

  /// Enable shared accounts
  static bool get enableSharedAccounts => false; // TODO: Implement in future

  /// Enable dark mode
  static bool get enableDarkMode => true;

  /// Enable animations
  static bool get enableAnimations => true;

  /// Enable haptic feedback
  static bool get enableHapticFeedback => true;

  // ============================================================================
  // FIREBASE CONFIGURATION
  // ============================================================================

  /// Use Firebase emulator (debug only)
  static bool get useFirebaseEmulator =>
      false; // Set to true when testing locally

  /// Firebase emulator host
  static String get firebaseEmulatorHost => 'localhost';

  /// Firestore emulator port
  static int get firestoreEmulatorPort => 8080;

  /// Auth emulator port
  static int get authEmulatorPort => 9099;

  /// Enable Firestore persistence
  static bool get enableFirestorePersistence => true;

  /// Enable Firebase Analytics
  static bool get enableFirebaseAnalytics => isRelease;

  /// Enable Firebase Crashlytics
  static bool get enableFirebaseCrashlytics => isRelease;

  /// Enable Firebase Performance Monitoring
  static bool get enableFirebasePerformance => isRelease;

  // ============================================================================
  // PERFORMANCE CONFIGURATION
  // ============================================================================

  /// Maximum number of items to load per page (pagination)
  static int get pageSize => 20;

  /// Enable image caching
  static bool get enableImageCaching => true;

  /// Maximum cache size in MB
  static int get maxCacheSizeMB => 100;

  /// Cache duration in days
  static int get cacheDurationDays => 7;

  /// Enable lazy loading
  static bool get enableLazyLoading => true;

  /// Debounce delay in milliseconds (for search, filters)
  static int get debounceDelayMs => 500;

  // ============================================================================
  // SECURITY CONFIGURATION
  // ============================================================================

  /// Enable SSL pinning
  static bool get enableSSLPinning => isRelease;

  /// Enable jailbreak/root detection
  static bool get enableRootDetection => isRelease;

  /// Enable screenshot prevention (sensitive screens)
  static bool get preventScreenshots => isRelease;

  /// Session timeout in minutes
  static int get sessionTimeoutMinutes => 30;

  /// Auto-lock after inactivity (minutes)
  static int get autoLockMinutes => 5;

  /// Require authentication on app resume
  static bool get requireAuthOnResume => false;

  // ============================================================================
  // UI/UX CONFIGURATION
  // ============================================================================

  /// Default locale (language)
  static String get defaultLocale => 'pt_BR';

  /// Supported locales
  static List<String> get supportedLocales => ['pt_BR'];

  /// Enable pull-to-refresh
  static bool get enablePullToRefresh => true;

  /// Enable swipe-to-delete
  static bool get enableSwipeToDelete => true;

  /// Enable undo for destructive actions
  static bool get enableUndoActions => true;

  /// Undo timeout in seconds
  static int get undoTimeoutSeconds => 3;

  /// Show loading indicators for operations > threshold
  static bool get showLoadingIndicators => true;

  /// Loading indicator threshold in milliseconds
  static int get loadingIndicatorThresholdMs => 500;

  // ============================================================================
  // VALIDATION CONFIGURATION
  // ============================================================================

  /// Enable real-time validation in forms
  static bool get enableRealtimeValidation => true;

  /// Enable autocorrect in text fields
  static bool get enableAutocorrect => true;

  /// Enable autocomplete in text fields
  static bool get enableAutocomplete => true;

  // ============================================================================
  // DATA SYNC CONFIGURATION
  // ============================================================================

  /// Enable automatic data sync
  static bool get enableAutoSync => true;

  /// Sync interval in minutes
  static int get syncIntervalMinutes => 15;

  /// Sync only on WiFi
  static bool get syncOnlyOnWifi => false;

  /// Enable background sync
  static bool get enableBackgroundSync => true;

  // ============================================================================
  // NOTIFICATION CONFIGURATION
  // ============================================================================

  /// Enable push notifications
  static bool get enablePushNotifications => true;

  /// Enable local notifications
  static bool get enableLocalNotifications => true;

  /// Show notification badge
  static bool get showNotificationBadge => true;

  // ============================================================================
  // DEVELOPMENT/DEBUG FEATURES
  // ============================================================================

  /// Show debug information on screen
  static bool get showDebugInfo => isDebug;

  /// Enable performance overlay
  static bool get showPerformanceOverlay => false; // Set to true when profiling

  /// Enable semantic debugger
  static bool get showSemanticDebugger => false;

  /// Enable widget inspector
  static bool get enableWidgetInspector => isDebug;

  /// Log API requests
  static bool get logApiRequests => isDebug;

  /// Log navigation events
  static bool get logNavigation => isDebug;

  /// Log state changes
  static bool get logStateChanges => isDebug;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Returns configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() {
    return {
      'environment': environment,
      'isDebug': isDebug,
      'enableLogging': enableLogging,
      'enableErrorReporting': enableErrorReporting,
      'enableAnalytics': enableAnalytics,
      'useFirebaseEmulator': useFirebaseEmulator,
      'enableFirestorePersistence': enableFirestorePersistence,
      'appVersion': '1.0.0', // Should match AppConstants.appVersion
    };
  }

  /// Prints configuration summary (debug only)
  static void printConfig() {
    if (isDebug) {
      print('=== OrçaMente Configuration ===');
      getConfigSummary().forEach((key, value) {
        print('$key: $value');
      });
      print('================================');
    }
  }

  /// Validates configuration consistency
  static bool validateConfig() {
    // Add validation logic here if needed
    // For example, check if required environment variables are set
    return true;
  }
}
