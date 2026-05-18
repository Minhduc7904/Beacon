enum FeedFilterType { all, me, friend }

class FeedFilter {
  final FeedFilterType type;
  final String? friendId;
  final String? friendName;

  const FeedFilter._({required this.type, this.friendId, this.friendName});

  const FeedFilter.all() : this._(type: FeedFilterType.all);

  const FeedFilter.me() : this._(type: FeedFilterType.me);

  const FeedFilter.friend({
    required String friendId,
    required String friendName,
  }) : this._(
         type: FeedFilterType.friend,
         friendId: friendId,
         friendName: friendName,
       );

  String get key {
    switch (type) {
      case FeedFilterType.all:
        return 'all';
      case FeedFilterType.me:
        return 'me';
      case FeedFilterType.friend:
        return 'friend:${friendId ?? ''}';
    }
  }

  String get label {
    switch (type) {
      case FeedFilterType.all:
        return 'Tất cả';
      case FeedFilterType.me:
        return 'Tôi';
      case FeedFilterType.friend:
        final name = friendName?.trim();
        return name == null || name.isEmpty ? 'Bạn bè' : name;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is FeedFilter &&
        other.type == type &&
        other.friendId == friendId;
  }

  @override
  int get hashCode => Object.hash(type, friendId);
}
