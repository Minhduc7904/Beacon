import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/message_groups/presentation/pages/message_group_list_page.dart';
import 'providers.dart';

void resetUserSessionProviders(WidgetRef ref) {
  ref.invalidate(homeCheckinNotifierProvider);
  ref.invalidate(feedProvider);
  ref.invalidate(friendsPresenceNotifierProvider);
  ref.invalidate(homeUnreadMessageCountsProvider);
  ref.invalidate(homeFeedFilterFriendsProvider);
  ref.invalidate(messageGroupListProvider);
  ref.invalidate(safetyMoodCalendarNotifierProvider);
  ref.invalidate(safetySettingsNotifierProvider);
}
