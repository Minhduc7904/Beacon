import 'package:flutter/material.dart';

import '../../config/app_router.dart';
import '../../config/app_routes.dart';
import '../../observers/app_route_stack_observer.dart';
import 'dev_models.dart';

class DevRoutesMenuSheet extends StatefulWidget {
  const DevRoutesMenuSheet({
    super.key,
    required this.initialMode,
    required this.onModeChanged,
  });

  final DevNavigationMode initialMode;
  final ValueChanged<DevNavigationMode> onModeChanged;

  @override
  State<DevRoutesMenuSheet> createState() => _DevRoutesMenuSheetState();
}

class _DevRoutesMenuSheetState extends State<DevRoutesMenuSheet> {
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
            separatorBuilder: (context, index) => const Divider(height: 1),
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
          separatorBuilder: (context, index) => const Divider(height: 1),
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
