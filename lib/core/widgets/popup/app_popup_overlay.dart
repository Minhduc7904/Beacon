import 'package:flutter/material.dart';

typedef AppPopupTriggerBuilder =
    Widget Function(BuildContext context, bool isOpen, VoidCallback toggle);
typedef AppPopupContentBuilder =
    Widget Function(BuildContext context, VoidCallback close);

class AppPopupOverlay extends StatefulWidget {
  const AppPopupOverlay({
    super.key,
    required this.triggerBuilder,
    required this.popupBuilder,
    this.gap = 10,
    this.barrierColor = const Color(0x33000000),
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final AppPopupTriggerBuilder triggerBuilder;
  final AppPopupContentBuilder popupBuilder;
  final double gap;
  final Color barrierColor;
  final BorderRadius borderRadius;

  @override
  State<AppPopupOverlay> createState() => _AppPopupOverlayState();
}

class _AppPopupOverlayState extends State<AppPopupOverlay> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool get _isOpen => _overlayEntry != null;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _hide();
      return;
    }

    _show();
  }

  void _show() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _hide,
                child: ColoredBox(color: widget.barrierColor),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              offset: Offset(0, widget.gap),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 10,
                borderRadius: widget.borderRadius,
                clipBehavior: Clip.antiAlias,
                child: widget.popupBuilder(context, _hide),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlayEntry!);
    setState(() {});
  }

  void _hide() {
    _removeOverlay();
    if (mounted) {
      setState(() {});
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.triggerBuilder(context, _isOpen, _toggle),
    );
  }
}
