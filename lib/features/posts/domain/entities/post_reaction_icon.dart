enum PostReactionIcon { heart, haha, like, sad, wow }

extension PostReactionIconValue on PostReactionIcon {
  String get value {
    switch (this) {
      case PostReactionIcon.heart:
        return 'heart';
      case PostReactionIcon.haha:
        return 'haha';
      case PostReactionIcon.like:
        return 'like';
      case PostReactionIcon.sad:
        return 'sad';
      case PostReactionIcon.wow:
        return 'wow';
    }
  }

  String get emoji {
    switch (this) {
      case PostReactionIcon.heart:
        return '❤️';
      case PostReactionIcon.haha:
        return '😂';
      case PostReactionIcon.like:
        return '👍';
      case PostReactionIcon.sad:
        return '😢';
      case PostReactionIcon.wow:
        return '😮';
    }
  }
}

PostReactionIcon? postReactionIconFromValue(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'heart':
      return PostReactionIcon.heart;
    case 'haha':
      return PostReactionIcon.haha;
    case 'like':
      return PostReactionIcon.like;
    case 'sad':
      return PostReactionIcon.sad;
    case 'wow':
      return PostReactionIcon.wow;
    default:
      return null;
  }
}
