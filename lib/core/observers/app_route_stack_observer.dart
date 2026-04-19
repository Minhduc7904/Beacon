import 'package:flutter/material.dart';

class AppRouteStackObserver extends NavigatorObserver {
  final List<Route<dynamic>> _trackedRoutes = <Route<dynamic>>[];
  final ValueNotifier<List<RouteStackItem>> stack =
      ValueNotifier<List<RouteStackItem>>(<RouteStackItem>[]);

  RouteStackItem _toItem(Route<dynamic> route) {
    final settings = route.settings;
    final name = settings.name;
    return RouteStackItem(
      name: name == null || name.isEmpty ? '(unnamed)' : name,
      routeType: route.runtimeType.toString(),
      arguments: settings.arguments,
    );
  }

  void _syncNotifier() {
    stack.value = _trackedRoutes.map(_toItem).toList(growable: false);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackedRoutes.add(route);
    _syncNotifier();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackedRoutes.remove(route);
    _syncNotifier();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackedRoutes.remove(route);
    _syncNotifier();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final oldIndex = _trackedRoutes.indexOf(oldRoute);
      if (oldIndex != -1) {
        if (newRoute != null) {
          _trackedRoutes[oldIndex] = newRoute;
        } else {
          _trackedRoutes.removeAt(oldIndex);
        }
        _syncNotifier();
        super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
        return;
      }
      _trackedRoutes.remove(oldRoute);
    }

    if (newRoute != null) {
      _trackedRoutes.add(newRoute);
    }

    _syncNotifier();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class RouteStackItem {
  final String name;
  final String routeType;
  final Object? arguments;

  const RouteStackItem({
    required this.name,
    required this.routeType,
    required this.arguments,
  });
}

final appRouteStackObserver = AppRouteStackObserver();
