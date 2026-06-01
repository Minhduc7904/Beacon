class RegisterLoginTestUser {
  const RegisterLoginTestUser({
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.familyName,
    required this.givenName,
    required this.username,
  });

  final String email;
  final String phoneNumber;
  final String password;
  final String familyName;
  final String givenName;
  final String username;

  static const defaultUser = RegisterLoginTestUser(
    email: 'integration.beacon@example.com',
    phoneNumber: '0912345678',
    password: 'Beacon@123',
    familyName: 'Nguyen',
    givenName: 'An',
    username: 'beacon_integration_an',
  );

  static const seededLoginUser = RegisterLoginTestUser(
    email: 'beacon.n2n.seed@example.com',
    phoneNumber: '+84987654321',
    password: 'Beacon@123',
    familyName: 'Beacon',
    givenName: 'Seed',
    username: 'beacon_n2n_seed',
  );
}
