import '../../domain/entities/post_page.dart';
import 'post_model.dart';

class PostPageModel extends PostPage {
  const PostPageModel({required super.items, required super.nextCursor});

  factory PostPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return PostPageModel(
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(PostModel.fromJson)
                .toList()
          : const <PostModel>[],
      nextCursor: json['nextCursor']?.toString(),
    );
  }
}
