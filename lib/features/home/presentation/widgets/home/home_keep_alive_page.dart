import 'package:flutter/material.dart';

class HomeKeepAlivePage extends StatefulWidget {
  const HomeKeepAlivePage({super.key, required this.child});

  final Widget child;

  @override
  State<HomeKeepAlivePage> createState() => _HomeKeepAlivePageState();
}

class _HomeKeepAlivePageState extends State<HomeKeepAlivePage>
    with AutomaticKeepAliveClientMixin<HomeKeepAlivePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
