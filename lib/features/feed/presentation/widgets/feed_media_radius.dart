import 'package:flutter/material.dart';

const _cameraBoxBorderRadius = 60.0;
const _cameraBoxHorizontalInset = 40.0;
const _cameraBoxMinSize = 240.0;
const _cameraBoxMaxSize = 420.0;

double feedMediaBorderRadiusForSize(BuildContext context, double mediaSize) {
  final cameraBoxSize = _cameraBoxSize(context);
  return mediaSize * (_cameraBoxBorderRadius / cameraBoxSize);
}

double _cameraBoxSize(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return (width - _cameraBoxHorizontalInset).clamp(
    _cameraBoxMinSize,
    _cameraBoxMaxSize,
  );
}
