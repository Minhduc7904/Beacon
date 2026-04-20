class HomeState {
  final bool isCameraInitializing;
  final bool isCapturing;
  final String? cameraError;
  final String? capturedImagePath;

  const HomeState({
    required this.isCameraInitializing,
    required this.isCapturing,
    required this.cameraError,
    required this.capturedImagePath,
  });

  const HomeState.initial()
    : isCameraInitializing = true,
      isCapturing = false,
      cameraError = null,
      capturedImagePath = null;

  bool get hasCapturedImage =>
      capturedImagePath != null && capturedImagePath!.isNotEmpty;

  bool get showBusy => isCapturing;

  HomeState copyWith({
    bool? isCameraInitializing,
    bool? isCapturing,
    String? cameraError,
    bool clearCameraError = false,
    String? capturedImagePath,
    bool clearCapturedImagePath = false,
  }) {
    return HomeState(
      isCameraInitializing: isCameraInitializing ?? this.isCameraInitializing,
      isCapturing: isCapturing ?? this.isCapturing,
      cameraError: clearCameraError ? null : (cameraError ?? this.cameraError),
      capturedImagePath: clearCapturedImagePath
          ? null
          : (capturedImagePath ?? this.capturedImagePath),
    );
  }
}
