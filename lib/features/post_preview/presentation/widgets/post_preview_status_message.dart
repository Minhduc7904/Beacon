import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';

class PostPreviewStatusMessage extends ConsumerWidget {
  const PostPreviewStatusMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.watch(
      postPreviewNotifierProvider.select((value) => value.errorMessage),
    );

    if (errorMessage == null || errorMessage.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
    );
  }
}
