class RegisterDraftData {
  const RegisterDraftData({
    this.email,
    this.password,
    this.familyName,
    this.givenName,
    this.username,
    this.phoneNumber,
  });

  final String? email;
  final String? password;
  final String? familyName;
  final String? givenName;
  final String? username;
  final String? phoneNumber;

  bool get hasEmail => email != null && email!.trim().isNotEmpty;

  bool get hasPassword => password != null && password!.isNotEmpty;

  bool get hasName =>
      familyName != null &&
      familyName!.trim().isNotEmpty &&
      givenName != null &&
      givenName!.trim().isNotEmpty;

  bool get hasUsername => username != null && username!.trim().isNotEmpty;

  bool get hasPhoneNumber =>
      phoneNumber != null && phoneNumber!.trim().isNotEmpty;

  RegisterDraftData copyWith({
    String? email,
    String? password,
    String? familyName,
    String? givenName,
    String? username,
    String? phoneNumber,
  }) {
    return RegisterDraftData(
      email: email ?? this.email,
      password: password ?? this.password,
      familyName: familyName ?? this.familyName,
      givenName: givenName ?? this.givenName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toApiPayload() {
    return {
      'email': email?.trim(),
      'password': password,
      'confirmPassword': password,
      'familyName': familyName?.trim(),
      'givenName': givenName?.trim(),
      'username': username?.trim(),
      'phoneNumber': phoneNumber?.trim(),
    };
  }
}
