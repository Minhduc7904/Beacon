import 'package:isar/isar.dart';

import '../../features/auth/data/local_models/user_profile_cache.dart';
import '../../features/safety/data/local_models/safety_settings_cache.dart';

final List<CollectionSchema<dynamic>> isarCollections = [
  SafetySettingsCacheSchema,
  UserProfileCacheSchema,
];
