/// Type-safe result wrapper for async operations
/// Eliminates need for try-catch in business logic
sealed class Result<T> {
  const Result();

  /// Check if result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull => isSuccess ? (this as Success<T>).data : null;

  /// Get error if failure, null otherwise
  String? get errorOrNull => isFailure ? (this as Failure<T>).error : null;

  /// Get exception if failure, null otherwise
  Exception? get exceptionOrNull =>
      isFailure ? (this as Failure<T>).exception : null;

  /// Transform data if success
  Result<R> map<R>(R Function(T data) transform) {
    if (this is Success<T>) {
      try {
        return Success(transform((this as Success<T>).data));
      } catch (e) {
        return Failure('Error transforming data: $e', Exception(e.toString()));
      }
    }
    return Failure(
      (this as Failure<T>).error,
      (this as Failure<T>).exception,
    );
  }

  /// Execute function based on result type
  R when<R>({
    required R Function(T data) success,
    required R Function(String error, Exception? exception) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    }
    return failure(
      (this as Failure<T>).error,
      (this as Failure<T>).exception,
    );
  }
}

/// Successful result containing data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Failed result containing error message and optional exception
class Failure<T> extends Result<T> {
  final String error;
  final Exception? exception;

  const Failure(this.error, [this.exception]);

  @override
  String toString() => 'Failure(error: $error, exception: $exception)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          exception == other.exception;

  @override
  int get hashCode => error.hashCode ^ exception.hashCode;
}
