import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class DevLayoutMenuSheet extends ConsumerWidget {
  const DevLayoutMenuSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showGrid = ref.watch(devShowLayoutGridProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Layout', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          CheckboxListTile(
            value: showGrid,
            title: const Text('Hiện layout grid'),
            onChanged: (value) {
              ref.read(devShowLayoutGridProvider.notifier).state = value ?? false;
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
