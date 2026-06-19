import 'package:dartz/dartz.dart';
import 'package:ledge/core/errors/exceptions.dart';
import 'package:ledge/core/errors/failure.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ledge/features/auth/domain/entities/user.dart';
import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import 'package:ledge/utils/typedef.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    /*
     Before writing code for this method we are supposed to write its test, under TDD
     For TDD things that this method should do :
     1) Should always call [AuthRemoteDataSource]
     2) Should return proper data if there is no failure else Should return failure expected data i.e. if server returns a Failure this should throw exception else it
        should return the actual result
    */
    try {
      // now we will try to call datasource fro creating user
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on ServerException catch(e) {
      // if any error we will throw Server Failure
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
