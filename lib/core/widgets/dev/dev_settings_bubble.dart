import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_router.dart';
import '../../config/app_routes.dart';
import '../../observers/app_route_stack_observer.dart';
import '../../providers/providers.dart';

enum DevNavigationMode { push, go }

class DevSettingsBubble extends ConsumerStatefulWidget {
  const DevSettingsBubble({super.key});

  @override
  ConsumerState<DevSettingsBubble> createState() => _DevSettingsBubbleState();
}

class _DevSettingsBubbleState extends ConsumerState<DevSettingsBubble> {
  DevNavigationMode _mode = DevNavigationMode.push;
  bool _isMenuOpen = false;

  Future<void> _openMainMenu() async {
    if (_isMenuOpen) {
      return;
    }

    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    setState(() {
      _isMenuOpen = true;
    });

    try {
      await showModalBottomSheet<void>(
        context: navigatorContext,
        builder: (sheetContext) {
          return _DevMainMenu(
            showLayoutMenu: kDebugMode,
            onOpenRoutes: () {
              Navigator.of(sheetContext).pop();
              _openRoutesMenu();
            },
            onOpenLayout: () {
              Navigator.of(sheetContext).pop();
              _openLayoutMenu();
            },
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isMenuOpen = false;
        });
      }
    }
  }

  Future<void> _openLayoutMenu() async {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      builder: (sheetContext) {
        return const _DevLayoutMenuSheet();
      },
    );
  }

  Future<void> _openRoutesMenu() async {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _DevRoutesMenuSheet(
          initialMode: _mode,
          onModeChanged: (mode) {
            setState(() {
              _mode = mode;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FloatingActionButton.small(
            heroTag: 'dev_settings_bubble',
            onPressed: _isMenuOpen ? null : _openMainMenu,
            child: const Icon(Icons.settings_rounded),
          ),
        ),
      ),
    );
  }
}

class _DevMainMenu extends StatelessWidget {
  const _DevMainMenu({
    required this.showLayoutMenu,
    required this.onOpenRoutes,
    required this.onOpenLayout,
  });

  final bool showLayoutMenu;
  final VoidCallback onOpenRoutes;
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

class _DevLayoutMenuSheet extends ConsumerWidget {
  const _DevLayoutMenuSheet();

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

class _DevRoutesMenuSheet extends StatefulWidget {
  const _DevRoutesMenuSheet({
    required this.initialMode,
    required this.onModeChanged,
  });

  final DevNavigationMode initialMode;
  final ValueChanged<DevNavigationMode> onModeChanged;

  @override
  State<_DevRoutesMenuSheet> createState() => _DevRoutesMenuSheetState();
}

class _DevRoutesMenuSheetState extends State<_DevRoutesMenuSheet> {
  late DevNavigationMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: mediaQuery.viewInsets.bottom + 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Danh sach route',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const TabBar(tabs: [Tab(text: 'Trang'), Tab(text: 'Stack')]),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    children: [
                      _RoutesTab(
                        mode: _mode,
                        onModeChanged: (mode) {
                          setState(() {
                            _mode = mode;
                          });
                          widget.onModeChanged(mode);
                        },
                      ),
                      const _RouteStackTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoutesTab extends StatelessWidget {
  const _RoutesTab({required this.mode, required this.onModeChanged});

  final DevNavigationMode mode;
  final ValueChanged<DevNavigationMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<DevNavigationMode>(
          segments: const [
            ButtonSegment<DevNavigationMode>(
              value: DevNavigationMode.push,
              label: Text('push'),
            ),
            ButtonSegment<DevNavigationMode>(
              value: DevNavigationMode.go,
              label: Text('go'),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (selection) {
            if (selection.isEmpty) {
              return;
            }
            onModeChanged(selection.first);
          },
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: AppRoutes.all.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              final route = AppRoutes.all[index];
              return ListTile(
                title: Text(route.title),
                subtitle: Text(route.path),
                trailing: Text(mode == DevNavigationMode.push ? 'push' : 'go'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (mode == DevNavigationMode.go) {
                    appRouter.go(route.path);
                    return;
                  }
                  appRouter.push(route.path);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RouteStackTab extends StatelessWidget {
  const _RouteStackTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<RouteStackItem>>(
      valueListenable: appRouteStackObserver.stack,
      builder: (context, stack, _) {
        if (stack.isEmpty) {
          return const Center(child: Text('Stack đang trống'));
        }

        return ListView.separated(
          itemCount: stack.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final item = stack[index];
            final order = index + 1;
            return ListTile(
              leading: CircleAvatar(radius: 14, child: Text('$order')),
              title: Text(item.name),
              subtitle: Text(
                'type: ${item.routeType}${item.arguments != null ? '\nargs: ${item.arguments}' : ''}',
              ),
            );
          },
        );
      },
    );
  }
}
