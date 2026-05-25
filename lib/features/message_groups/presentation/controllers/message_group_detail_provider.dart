import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/entities/message_group_detail.dart';

final messageGroupDetailProvider = FutureProvider.autoDispose
    .family<MessageGroupDetail, String>((ref, groupId) async {
      final result = await ref
          .watch(getMessageGroupDetailUseCaseProvider)
          .call(groupId: groupId);

      return result.fold((failure) => throw failure, (detail) => detail);
    });
