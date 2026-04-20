import 'tokens.dart';
import 'user.dart';

class AuthResult {
  final String message;
  final Tokens tokens;
  final User user;

  AuthResult({
    required this.message,
    required this.tokens,
    required this.user,
  });
}
