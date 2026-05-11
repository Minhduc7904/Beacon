import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_env.dart';
import '../../providers/providers.dart';

class AppScreenLayout extends StatelessWidget {
  const AppScreenLayout({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.topCenter,
  });

  static const double columnWidth = 80;
  static const double gutter = 20;
  static const double minHorizontalSafeInset = 16;
  static const int mobileColumnCount = 4;
  static const int tabletColumnCount = 8;
  static const double tabletBreakpoint = 768;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  double _contentWidthForColumns(int columns) {
    return (columnWidth * columns) + (gutter * (columns - 1));
  }

  double _layoutWidth({
    required double availableWidth,
    required double designWidth,
  }) {
    final maxSafeWidth = math.max(
      0.0,
      availableWidth - minHorizontalSafeInset * 2,
    );
    return math.min(designWidth, maxSafeWidth);
  }

  @override
  Widget build(BuildContext context) {
    if (!AppEnv.isDev) {
      return _buildLayout(context, showGrid: false);
    }

    return Consumer(
      builder: (context, ref, _) {
        final showGrid = ref.watch(devShowLayoutGridProvider);
        return _buildLayout(context, showGrid: showGrid);
      },
    );
  }

  Widget _buildLayout(BuildContext context, {required bool showGrid}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final layoutHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        final isTablet = maxWidth >= tabletBreakpoint;
        final columnCount = isTablet ? tabletColumnCount : mobileColumnCount;
        final contentWidth = _contentWidthForColumns(columnCount);
        final layoutWidth = _layoutWidth(
          availableWidth: maxWidth,
          designWidth: contentWidth,
        );

        return Align(
          alignment: alignment,
          child: SizedBox(
            width: layoutWidth,
            height: layoutHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(padding: padding, child: child),
                if (showGrid)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(columnCount * 2 - 1, (index) {
                          if (index.isEven) {
                            return Expanded(
                              flex: (columnWidth * 10).round(),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.14),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.45),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Expanded(
                            flex: (gutter * 10).round(),
                            child: const SizedBox.shrink(),
                          );
                        }),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
