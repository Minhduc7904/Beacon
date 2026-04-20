import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_router.dart';
import 'dev_api_menu_sheet.dart';
import 'dev_layout_menu_sheet.dart';
import 'dev_main_menu_sheet.dart';
import 'dev_models.dart';
import 'dev_routes_menu_sheet.dart';

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
          return DevMainMenuSheet(
            showLayoutMenu: kDebugMode,
            onOpenRoutes: () {
              Navigator.of(sheetContext).pop();
              _openRoutesMenu();
            },
            onOpenApi: () {
              Navigator.of(sheetContext).pop();
              _openApiMenu();
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
        return const DevLayoutMenuSheet();
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
        return DevRoutesMenuSheet(
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

  Future<void> _openApiMenu() async {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      isScrollControlled: true,
      builder: (sheetContext) {
        return const DevApiMenuSheet();
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
