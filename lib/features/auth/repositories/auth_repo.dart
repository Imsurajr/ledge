import 'package:dartz/dartz.dart';
import 'package:ledge/core/errors/failure.dart';

import '../domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();
  Future<Either<Failure, void>> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<Either<Failure, List<User>>> getUsers();
}
