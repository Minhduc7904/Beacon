import 'package:flutter/material.dart';

class DevMainMenuSheet extends StatelessWidget {
  const DevMainMenuSheet({
    super.key,
    required this.showLayoutMenu,
    required this.onOpenRoutes,
    required this.onOpenApi,
    required this.onOpenTest,
    required this.onOpenLayout,
  });

  final bool showLayoutMenu;
  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenApi;
  final VoidCallback onOpenTest;
  final VoidCallback onOpenLayout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Dev Menu', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          ListTile(
            leading: const Icon(Icons.route_rounded),
            title: const Text('Trang'),
            onTap: onOpenRoutes,
          ),
          ListTile(
            leading: const Icon(Icons.cloud_rounded),
            title: const Text('API'),
            onTap: onOpenApi,
          ),
          ListTile(
            leading: const Icon(Icons.science_rounded),
            title: const Text('Test'),
            onTap: onOpenTest,
          ),
          if (showLayoutMenu)
            ListTile(
              leading: const Icon(Icons.grid_view_rounded),
              title: const Text('Layout'),
              onTap: onOpenLayout,
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
