import '../models/group_message_model.dart';
import '../models/group_message_page_model.dart';
import '../models/message_group_detail_model.dart';
import '../models/message_group_page_model.dart';

abstract class MessageGroupsRemoteDatasource {
  Future<MessageGroupPageModel> getMessageGroups({String? cursor, int? limit});

  Future<GroupMessageModel> sendMessage({
    required String groupId,
    required String content,
  });

  Future<GroupMessageModel> sendPostMessage({
    required String postId,
    required String clientMessageId,
    String? content,
  });

  Future<GroupMessagePageModel> getMessages({
    required String groupId,
    String? cursor,
    int? limit,
  });

  Future<MessageGroupDetailModel> getGroupDetail({required String groupId});

  Future<void> markSeen({
    required String groupId,
    required String lastSeenMessageId,
  });
}
