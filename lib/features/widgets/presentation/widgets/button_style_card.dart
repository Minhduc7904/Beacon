import 'package:flutter/material.dart' hide Card;

import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/card/card.dart';
import '../../../../core/widgets/dropdown/dropdown.dart';

class ButtonStyleCard extends StatefulWidget {
  const ButtonStyleCard({super.key});

  @override
  State<ButtonStyleCard> createState() => _ButtonStyleCardState();
}

class _ButtonStyleCardState extends State<ButtonStyleCard> {
  ButtonMode _mode = ButtonMode.light;
  ButtonSize _size = ButtonSize.block;
  ButtonType _type = ButtonType.primary;
  ButtonState _state = ButtonState.defaultState;
  bool _hasIcon = false;
  ButtonIconPosition _iconPosition = ButtonIconPosition.side;

  @override
  Widget build(BuildContext context) {
    return Card(
      title: 'Button Playground',
      description: 'Chọn style để xem preview Button theo từng option.',
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                text: 'Button',
                mode: _mode,
                size: _size,
                type: _type,
                state: _state,
                hasIcon: _hasIcon,
                iconPosition: _iconPosition,
                icon: const Icon(Icons.check_rounded, size: 16),
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              AppDropdown<ButtonMode>(
                labelText: 'Mode',
                value: _mode,
                items: ButtonMode.values
                    .map(
                      (value) => AppDropdownItem<ButtonMode>(
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
              AppDropdown<ButtonSize>(
                labelText: 'Size',
                value: _size,
                items: ButtonSize.values
                    .map(
                      (value) => AppDropdownItem<ButtonSize>(
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
              AppDropdown<ButtonType>(
                labelText: 'Type',
                value: _type,
                items: ButtonType.values
                    .map(
                      (value) => AppDropdownItem<ButtonType>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _type = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<ButtonState>(
                labelText: 'State',
                value: _state,
                items: ButtonState.values
                    .map(
                      (value) => AppDropdownItem<ButtonState>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _state = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<bool>(
                labelText: 'Icon',
                value: _hasIcon,
                items: const [
                  AppDropdownItem<bool>(value: false, label: 'False'),
                  AppDropdownItem<bool>(value: true, label: 'True'),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _hasIcon = value);
                },
              ),
              const SizedBox(height: 8),
              AppDropdown<ButtonIconPosition>(
                labelText: 'Icon Position',
                value: _iconPosition,
                enabled: _hasIcon,
                items: ButtonIconPosition.values
                    .map(
                      (value) => AppDropdownItem<ButtonIconPosition>(
                        value: value,
                        label: value.label,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _iconPosition = value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _ButtonModeLabel on ButtonMode {
  String get label {
    return switch (this) {
      ButtonMode.light => 'Light',
      ButtonMode.dark => 'Dark',
    };
  }
}

extension _ButtonSizeLabel on ButtonSize {
  String get label {
    return switch (this) {
      ButtonSize.block => 'Block',
      ButtonSize.large => 'Large',
      ButtonSize.small => 'Small',
    };
  }
}

extension _ButtonTypeLabel on ButtonType {
  String get label {
    return switch (this) {
      ButtonType.primary => 'Primary',
      ButtonType.secondary => 'Secondary',
      ButtonType.outline => 'Outline',
      ButtonType.transparent => 'Transparent',
    };
  }
}

extension _ButtonStateLabel on ButtonState {
  String get label {
    return switch (this) {
      ButtonState.defaultState => 'Default',
      ButtonState.pressed => 'Pressed',
      ButtonState.disabled => 'Disabled',
    };
  }
}

extension _ButtonIconPositionLabel on ButtonIconPosition {
  String get label {
    return switch (this) {
      ButtonIconPosition.side => 'Side',
      ButtonIconPosition.left => 'Left',
      ButtonIconPosition.right => 'Right',
    };
  }
}
