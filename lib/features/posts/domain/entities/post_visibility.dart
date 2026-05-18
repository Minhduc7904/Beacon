enum PostVisibility { friends, private }

extension PostVisibilityValue on PostVisibility {
  String get value {
    switch (this) {
      case PostVisibility.friends:
        return 'friends';
      case PostVisibility.private:
        return 'private';
    }
  }
}

PostVisibility postVisibilityFromValue(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'private':
      return PostVisibility.private;
    case 'friends':
    default:
      return PostVisibility.friends;
  }
}
