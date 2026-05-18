class HomeState {
  final bool isCameraInitializing;
  final bool isCameraReady;
  final bool isCapturing;
  final bool isFlashEnabled;
  final bool isUsingFrontCamera;
  final bool isScreenFlashVisible;
  final String? cameraError;
  final String? capturedImagePath;

  const HomeState({
    required this.isCameraInitializing,
    required this.isCameraReady,
    required this.isCapturing,
    required this.isFlashEnabled,
    required this.isUsingFrontCamera,
    required this.isScreenFlashVisible,
    required this.cameraError,
    required this.capturedImagePath,
  });

  const HomeState.initial()
    : isCameraInitializing = true,
      isCameraReady = false,
      isCapturing = false,
      isFlashEnabled = false,
      isUsingFrontCamera = false,
      isScreenFlashVisible = false,
      cameraError = null,
      capturedImagePath = null;

  bool get hasCapturedImage =>
      capturedImagePath != null && capturedImagePath!.isNotEmpty;

  bool get showBusy => isCapturing;

  bool get canToggleFlash =>
      isCameraReady &&
      !isCameraInitializing &&
      !isCapturing &&
      !isUsingFrontCamera &&
      cameraError == null;

  HomeState copyWith({
    bool? isCameraInitializing,
    bool? isCameraReady,
    bool? isCapturing,
    bool? isFlashEnabled,
    bool? isUsingFrontCamera,
    bool? isScreenFlashVisible,
    String? cameraError,
    bool clearCameraError = false,
    String? capturedImagePath,
    bool clearCapturedImagePath = false,
  }) {
    return HomeState(
      isCameraInitializing: isCameraInitializing ?? this.isCameraInitializing,
      isCameraReady: isCameraReady ?? this.isCameraReady,
      isCapturing: isCapturing ?? this.isCapturing,
      isFlashEnabled: isFlashEnabled ?? this.isFlashEnabled,
      isUsingFrontCamera: isUsingFrontCamera ?? this.isUsingFrontCamera,
      isScreenFlashVisible: isScreenFlashVisible ?? this.isScreenFlashVisible,
      cameraError: clearCameraError ? null : (cameraError ?? this.cameraError),
      capturedImagePath: clearCapturedImagePath
          ? null
          : (capturedImagePath ?? this.capturedImagePath),
    );
  }
}
