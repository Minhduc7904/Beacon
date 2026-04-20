import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecase/update_me_usecase.dart';
import '../../controllers/profile_state.dart';
import '../../../../../core/providers/providers.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _familyNameController;
  late final TextEditingController _givenNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  String? _familyNameError;
  String? _givenNameError;
  String? _emailError;
  String? _phoneError;

  String get _initialFamilyName => widget.profile.familyName.trim();
  String get _initialGivenName => widget.profile.givenName.trim();
  String get _initialEmail => widget.profile.email.trim();
  String get _initialPhone => (widget.profile.phoneNumber ?? '').trim();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.username);
    _familyNameController = TextEditingController(
      text: widget.profile.familyName,
    );
    _givenNameController = TextEditingController(
      text: widget.profile.givenName,
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _familyNameController.dispose();
    _givenNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _familyName => _familyNameController.text.trim();
  String get _givenName => _givenNameController.text.trim();
  String get _email => _emailController.text.trim();
  String get _phone => _phoneController.text.trim();

  bool get _hasChanges {
    return _familyName != _initialFamilyName ||
        _givenName != _initialGivenName ||
        _email != _initialEmail ||
        _phone != _initialPhone;
  }

  bool _validate() {
    String? familyNameError;
    String? givenNameError;
    String? emailError;
    String? phoneError;

    if (_familyName.isEmpty) {
      familyNameError = 'Họ không được để trống';
    }

    if (_givenName.isEmpty) {
      givenNameError = 'Tên không được để trống';
    }

    if (_email.isEmpty) {
      emailError = 'Email không được để trống';
    } else {
      final isValidEmail = RegExp(
        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
        caseSensitive: false,
      ).hasMatch(_email);
      if (!isValidEmail) {
        emailError = 'Email không đúng định dạng';
      }
    }

    if (_phone.isEmpty) {
      phoneError = 'Số điện thoại không được để trống';
    }

    setState(() {
      _familyNameError = familyNameError;
      _givenNameError = givenNameError;
      _emailError = emailError;
      _phoneError = phoneError;
    });

    return familyNameError == null &&
        givenNameError == null &&
        emailError == null &&
        phoneError == null;
  }

  Future<void> _onSavePressed(ProfileState state) async {
    if (state.isUpdatingProfile || !_hasChanges || !_validate()) {
      return;
    }

    final params = UpdateMeParams(
      familyName: _familyName != _initialFamilyName ? _familyName : null,
      givenName: _givenName != _initialGivenName ? _givenName : null,
      email: _email != _initialEmail ? _email : null,
      phoneNumber: _phone != _initialPhone ? _phone : null,
    );

    final success = await ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(params);

    if (mounted && success) {
      context.pop();
    }
  }

  InputState _resolveState(String value, String? error) {
    if (error != null && error.isNotEmpty) {
      return InputState.error;
    }

    if (value.trim().isNotEmpty) {
      return InputState.filled;
    }

    return InputState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final canSave = _hasChanges && !profileState.isUpdatingProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: AppScreenLayout(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Input(
                      labelText: 'Username',
                      controller: _usernameController,
                      enabled: false,
                      state: InputState.disabled,
                    ),
                    const SizedBox(height: 14),
                    Input(
                      labelText: 'Họ',
                      controller: _familyNameController,
                      onChanged: (_) {
                        if (_familyNameError != null) {
                          setState(() => _familyNameError = null);
                        } else {
                          setState(() {});
                        }
                      },
                      caption: _familyNameError,
                      state: _resolveState(
                        _familyNameController.text,
                        _familyNameError,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Input(
                      labelText: 'Tên',
                      controller: _givenNameController,
                      onChanged: (_) {
                        if (_givenNameError != null) {
                          setState(() => _givenNameError = null);
                        } else {
                          setState(() {});
                        }
                      },
                      caption: _givenNameError,
                      state: _resolveState(
                        _givenNameController.text,
                        _givenNameError,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Input(
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        } else {
                          setState(() {});
                        }
                      },
                      caption: _emailError,
                      state: _resolveState(_emailController.text, _emailError),
                    ),
                    const SizedBox(height: 14),
                    Input(
                      labelText: 'Số điện thoại',
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      onChanged: (_) {
                        if (_phoneError != null) {
                          setState(() => _phoneError = null);
                        } else {
                          setState(() {});
                        }
                      },
                      caption: _phoneError,
                      state: _resolveState(_phoneController.text, _phoneError),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.6),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            'Múi giờ',
                            preset: AppTextPreset.bodySmall,
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            widget.profile.timeZone,
                            preset: AppTextPreset.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          const AppText(
                            'Trường này chỉ đọc theo backend hiện tại.',
                            preset: AppTextPreset.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Button(
                text: 'Lưu thay đổi',
                isLoading: profileState.isUpdatingProfile,
                state: canSave
                    ? ButtonState.defaultState
                    : ButtonState.disabled,
                onPressed: canSave ? () => _onSavePressed(profileState) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
