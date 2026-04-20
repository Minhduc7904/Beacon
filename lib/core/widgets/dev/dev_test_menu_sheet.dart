import 'package:flutter/material.dart';

class DevTestMenuSheet extends StatelessWidget {
  const DevTestMenuSheet({
    super.key,
    required this.onOpenTestPostMedia,
  });

  final VoidCallback onOpenTestPostMedia;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Test Menu', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          ListTile(
            leading: const Icon(Icons.send_rounded),
            title: const Text('Test post media'),
            onTap: onOpenTestPostMedia,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
