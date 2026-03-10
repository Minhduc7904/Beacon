import 'tokens.dart';
import 'user.dart';

class AuthResult {
  final Tokens tokens;
  final User user;

  AuthResult({required this.tokens, required this.user});
}
