import 'package:isar/isar.dart';

import '../../features/auth/data/local_models/user_profile_cache.dart';
import '../../features/message_groups/data/local_models/group_message_cache.dart';
import '../../features/message_groups/data/local_models/group_message_list_cache.dart';
import '../../features/message_groups/data/local_models/message_group_cache.dart';
import '../../features/message_groups/data/local_models/message_group_detail_cache.dart';
import '../../features/message_groups/data/local_models/message_group_list_cache.dart';
import '../../features/posts/data/local_models/post_cache.dart';
import '../../features/posts/data/local_models/post_list_cache.dart';
import '../../features/safety/data/local_models/monthly_checkins_cache.dart';
import '../../features/safety/data/local_models/safety_settings_cache.dart';

final List<CollectionSchema<dynamic>> isarCollections = [
  GroupMessageCacheSchema,
  GroupMessageListCacheSchema,
  MessageGroupCacheSchema,
  MessageGroupDetailCacheSchema,
  MessageGroupListCacheSchema,
  MonthlyCheckinsCacheSchema,
  PostCacheSchema,
  PostListCacheSchema,
  SafetySettingsCacheSchema,
  UserProfileCacheSchema,
];
