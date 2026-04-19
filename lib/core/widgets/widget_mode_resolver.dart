import 'package:flutter/material.dart' as m;

T resolveWidgetMode<T>({
  required m.BuildContext context,
  required T? mode,
  required T lightMode,
  required T darkMode,
}) {
  if (mode != null) {
    return mode;
  }

  final brightness = m.Theme.of(context).brightness;
  return brightness == m.Brightness.dark ? darkMode : lightMode;
}
