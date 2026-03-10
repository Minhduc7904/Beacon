import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, String>> logout();
}
