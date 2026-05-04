import '../../domain/entities/feed_post.dart';
import '../../domain/entities/feed_reaction.dart';

/// Mock data for the feed feature — uses royalty-free placeholder images.
class FeedMockData {
  FeedMockData._();

  static final List<FeedPost> posts = List.unmodifiable([
    FeedPost(
      id: 'feed_1',
      authorName: 'Minh Anh',
      imageUrl: 'https://picsum.photos/seed/beacon1/600/600',
      caption: 'Bình minh hôm nay đẹp quá! ☀️',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      reactions: [
        FeedReaction(
          id: 'r1',
          userName: 'Hải Đăng',
          type: ReactionType.heart,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        FeedReaction(
          id: 'r2',
          userName: 'Thu Hà',
          type: ReactionType.fire,
          createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
        ),
      ],
    ),
    FeedPost(
      id: 'feed_2',
      authorName: 'Hải Đăng',
      imageUrl: 'https://picsum.photos/seed/beacon2/600/600',
      caption: 'Check-in xong rồi, an toàn nhé! 🔥',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      reactions: [
        FeedReaction(
          id: 'r3',
          userName: 'Minh Anh',
          type: ReactionType.clap,
          createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
        ),
      ],
    ),
    FeedPost(
      id: 'feed_3',
      authorName: 'Thu Hà',
      imageUrl: 'https://picsum.photos/seed/beacon3/600/600',
      caption: 'Cà phê sáng 🌸',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      reactions: [
        FeedReaction(
          id: 'r4',
          userName: 'Ngọc Trâm',
          type: ReactionType.heart,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        FeedReaction(
          id: 'r5',
          userName: 'Quốc Bảo',
          type: ReactionType.wow,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        FeedReaction(
          id: 'r6',
          userName: 'Đức Huy',
          type: ReactionType.heart,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
    FeedPost(
      id: 'feed_4',
      authorName: 'Quốc Bảo',
      imageUrl: 'https://picsum.photos/seed/beacon4/600/600',
      caption: 'Hôm nay mình cảm thấy rất tốt 💪',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      reactions: [],
    ),
    FeedPost(
      id: 'feed_5',
      authorName: 'Ngọc Trâm',
      imageUrl: 'https://picsum.photos/seed/beacon5/600/600',
      caption: 'Chúc mọi người ngày mới vui vẻ! 🌙',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      reactions: [
        FeedReaction(
          id: 'r7',
          userName: 'Minh Anh',
          type: ReactionType.heart,
          createdAt: DateTime.now().subtract(const Duration(hours: 7)),
        ),
      ],
    ),
    FeedPost(
      id: 'feed_6',
      authorName: 'Đức Huy',
      imageUrl: 'https://picsum.photos/seed/beacon6/600/600',
      caption: 'Streak 7 ngày rồi 🔥🔥🔥',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      reactions: [
        FeedReaction(
          id: 'r8',
          userName: 'Thu Hà',
          type: ReactionType.fire,
          createdAt: DateTime.now().subtract(const Duration(hours: 20)),
        ),
        FeedReaction(
          id: 'r9',
          userName: 'Hải Đăng',
          type: ReactionType.clap,
          createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        ),
      ],
    ),
  ]);
}
