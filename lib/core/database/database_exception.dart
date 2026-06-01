class DatabaseException implements Exception {
  final String message;
  final Object? cause;

  const DatabaseException(this.message, {this.cause});

  @override
  String toString() {
    final cause = this.cause;
    if (cause == null) {
      return 'DatabaseException: $message';
    }

    return 'DatabaseException: $message ($cause)';
  }
}
