class PostReportState {
  final bool isSubmitting;
  final bool didSubmit;
  final String? errorMessage;

  const PostReportState({
    this.isSubmitting = false,
    this.didSubmit = false,
    this.errorMessage,
  });

  PostReportState copyWith({
    bool? isSubmitting,
    bool? didSubmit,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PostReportState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      didSubmit: didSubmit ?? this.didSubmit,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
