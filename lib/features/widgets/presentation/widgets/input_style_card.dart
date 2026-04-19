import 'package:flutter/material.dart' hide Card;

import '../../../../core/widgets/card/card.dart';
import '../../../../core/widgets/dropdown/dropdown.dart';
import '../../../../core/widgets/input/input.dart';

class InputStyleCard extends StatefulWidget {
  const InputStyleCard({super.key});

  @override
  State<InputStyleCard> createState() => _InputStyleCardState();
}

class _InputStyleCardState extends State<InputStyleCard> {
  InputMode _mode = InputMode.light;
  InputType _type = InputType.text;
  InputState _state = InputState.defaultState;
  final TextEditingController _hintController = TextEditingController(
    text: 'Nhap noi dung...',
  );
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _hintController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      title: 'Input Playground',
      description: 'Chon style de xem preview Input theo tung option.',
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Input(
                label: null,
                hintText: _hintController.text,
                caption: _captionController.text,
                mode: _mode,
                type: _type,
                state: _state,
                leftIcon: _type == InputType.leftIcon
                    ? const Icon(Icons.search_rounded, size: 24)
                    : null,
              ),
              const SizedBox(height: 12),
              AppDropdown<InputMode>(
                labelText: 'Mode',
                value: _mode,
                items: InputMode.values
                    .map(
                      (value) => AppDropdownItem<InputMode>(
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
              AppDropdown<InputType>(
                labelText: 'Type',
                value: _type,
                items: InputType.values
                    .map(
                      (value) => AppDropdownItem<InputType>(
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
              AppDropdown<InputState>(
                labelText: 'State',
                value: _state,
                items: InputState.values
                    .map(
                      (value) => AppDropdownItem<InputState>(
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
              Input(
                label: 'Hint',
                hintText: 'Nhap hint...',
                controller: _hintController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Input(
                label: 'Caption',
                hintText: 'Nhap caption...',
                controller: _captionController,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _InputModeLabel on InputMode {
  String get label {
    return switch (this) {
      InputMode.light => 'Light',
      InputMode.dark => 'Dark',
    };
  }
}

extension _InputTypeLabel on InputType {
  String get label {
    return switch (this) {
      InputType.text => 'Text',
      InputType.leftIcon => 'Left Icon',
      InputType.dropdown => 'Dropdown',
    };
  }
}

extension _InputStateLabel on InputState {
  String get label {
    return switch (this) {
      InputState.defaultState => 'Default',
      InputState.focused => 'Focused',
      InputState.filled => 'Filled',
      InputState.error => 'Error',
      InputState.disabled => 'Disabled',
    };
  }
}
