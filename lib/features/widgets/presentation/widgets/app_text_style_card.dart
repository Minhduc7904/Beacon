import 'package:flutter/material.dart' hide Card;

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/card/card.dart';
import '../../../../core/widgets/dropdown/dropdown.dart';
import '../../../../core/widgets/text/text.dart';

enum _AppTextMode { preset, token }

class AppTextStyleCard extends StatefulWidget {
  const AppTextStyleCard({super.key});

  @override
  State<AppTextStyleCard> createState() => _AppTextStyleCardState();
}

class _AppTextStyleCardState extends State<AppTextStyleCard> {
  _AppTextMode _mode = _AppTextMode.preset;
  AppTextPreset _preset = AppTextPreset.title2;
  AppTextSize _size = AppTextSize.regular;
  AppTextSpacing _spacing = AppTextSpacing.normal;
  AppTextWeight _weight = AppTextWeight.regular;
  TextAlign _textAlign = TextAlign.left;

  @override
  Widget build(BuildContext context) {
    return Card(
      title: 'AppText Playground',
      description: 'Chọn option để xem preview AppText theo từng style.',
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                'Design System Text Preview',
                preset: _mode == _AppTextMode.preset ? _preset : null,
                size: _mode == _AppTextMode.token ? _size : null,
                spacing: _mode == _AppTextMode.token ? _spacing : null,
                weight: _mode == _AppTextMode.token ? _weight : null,
                textAlign: _textAlign,
              ),
              const SizedBox(height: 12),
              AppDropdown<_AppTextMode>(
                labelText: 'Mode',
                value: _mode,
                items: _AppTextMode.values
                    .map(
                      (value) => AppDropdownItem<_AppTextMode>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _mode = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<AppTextPreset>(
                labelText: 'Preset',
                value: _preset,
                enabled: _mode == _AppTextMode.preset,
                items: AppTextPreset.values
                    .map(
                      (value) => AppDropdownItem<AppTextPreset>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _preset = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<AppTextSize>(
                labelText: 'Size',
                value: _size,
                enabled: _mode == _AppTextMode.token,
                items: AppTextSize.values
                    .map(
                      (value) => AppDropdownItem<AppTextSize>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _size = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<AppTextSpacing>(
                labelText: 'Spacing',
                value: _spacing,
                enabled: _mode == _AppTextMode.token,
                items: AppTextSpacing.values
                    .map(
                      (value) => AppDropdownItem<AppTextSpacing>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _spacing = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<AppTextWeight>(
                labelText: 'Weight',
                value: _weight,
                enabled: _mode == _AppTextMode.token,
                items: AppTextWeight.values
                    .map(
                      (value) => AppDropdownItem<AppTextWeight>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _weight = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<TextAlign>(
                labelText: 'Text Align',
                value: _textAlign,
                items: const [
                  AppDropdownItem<TextAlign>(
                    value: TextAlign.left,
                    label: 'Left',
                  ),
                  AppDropdownItem<TextAlign>(
                    value: TextAlign.center,
                    label: 'Center',
                  ),
                  AppDropdownItem<TextAlign>(
                    value: TextAlign.right,
                    label: 'Right',
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _textAlign = value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _AppTextModeLabel on _AppTextMode {
  String get label {
    return switch (this) {
      _AppTextMode.preset => 'Preset',
      _AppTextMode.token => 'Token',
    };
  }
}

extension _AppTextPresetLabel on AppTextPreset {
  String get label {
    return switch (this) {
      AppTextPreset.title1 => 'Title 1',
      AppTextPreset.title2 => 'Title 2',
      AppTextPreset.title3 => 'Title 3',
      AppTextPreset.titleLarge => 'Title Large',
      AppTextPreset.titleMedium => 'Title Medium',
      AppTextPreset.bodyLarge => 'Body Large',
      AppTextPreset.bodyMedium => 'Body Medium',
      AppTextPreset.bodySmall => 'Body Small',
      AppTextPreset.labelLarge => 'Label Large',
      AppTextPreset.labelMedium => 'Label Medium',
      AppTextPreset.labelSmall => 'Label Small',
    };
  }
}

extension _AppTextSizeLabel on AppTextSize {
  String get label {
    return switch (this) {
      AppTextSize.large => 'Large',
      AppTextSize.regular => 'Regular',
      AppTextSize.small => 'Small',
      AppTextSize.tiny => 'Tiny',
      AppTextSize.veryTiny => 'Very Tiny',
    };
  }
}

extension _AppTextSpacingLabel on AppTextSpacing {
  String get label {
    return switch (this) {
      AppTextSpacing.none => 'None',
      AppTextSpacing.tight => 'Tight',
      AppTextSpacing.normal => 'Normal',
    };
  }
}

extension _AppTextWeightLabel on AppTextWeight {
  String get label {
    return switch (this) {
      AppTextWeight.bold => 'Bold',
      AppTextWeight.medium => 'Medium',
      AppTextWeight.regular => 'Regular',
    };
  }
}
