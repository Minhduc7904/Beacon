import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Increment this value to request a one-shot send action on PostPreview.
final testPostMediaSendSignalProvider = StateProvider<int>((ref) => 0);
