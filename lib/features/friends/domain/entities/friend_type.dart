enum FriendType { family, closeFriend, normal, custom }

extension FriendTypeValue on FriendType {
  int get value {
    switch (this) {
      case FriendType.family:
        return 0;
      case FriendType.closeFriend:
        return 1;
      case FriendType.normal:
        return 2;
      case FriendType.custom:
        return 3;
    }
  }

  static FriendType fromValue(int value) {
    switch (value) {
      case 0:
        return FriendType.family;
      case 1:
        return FriendType.closeFriend;
      case 3:
        return FriendType.custom;
      case 2:
      default:
        return FriendType.normal;
    }
  }
}
