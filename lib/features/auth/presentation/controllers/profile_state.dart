class ProfileState {
  final bool isLoadingProfile;
  final bool isUpdatingProfile;
  final bool isUpdatingAvatar;
  final String? errorMessage;

  const ProfileState({
    required this.isLoadingProfile,
    required this.isUpdatingProfile,
    required this.isUpdatingAvatar,
    required this.errorMessage,
  });

  const ProfileState.initial()
    : isLoadingProfile = false,
      isUpdatingProfile = false,
      isUpdatingAvatar = false,
      errorMessage = null;

  bool get isBusy => isLoadingProfile || isUpdatingProfile || isUpdatingAvatar;

  ProfileState copyWith({
    bool? isLoadingProfile,
    bool? isUpdatingProfile,
    bool? isUpdatingAvatar,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProfileState(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      isUpdatingAvatar: isUpdatingAvatar ?? this.isUpdatingAvatar,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
