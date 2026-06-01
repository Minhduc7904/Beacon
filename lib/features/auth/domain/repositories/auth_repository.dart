import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> checkEmailAvailable({required String email});
  Future<Either<Failure, bool>> checkPhoneAvailable({
    required String phoneNumber,
  });

  Future<Either<Failure, AuthResult>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String confirmPassword,
    required String familyName,
    required String givenName,
    required String username,
    required String password,
    required String phoneNumber,
  });

  Future<Either<Failure, String>> logout();

  Future<Either<Failure, bool>> hasLocalSession();

  Future<Either<Failure, UserProfile>> getMe();

  Future<Either<Failure, UserProfile>> updateMe({
    String? familyName,
    String? givenName,
    String? email,
    String? phoneNumber,
  });

  Future<Either<Failure, UserProfile>> updateMyAvatar({
    required String filePath,
  });

  Future<Either<Failure, void>> updateFcmToken({
    required String token,
    required String platform,
  });

  Future<Either<Failure, void>> deleteFcmToken({required String token});
}
