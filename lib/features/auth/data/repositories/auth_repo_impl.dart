import 'package:dartz/dartz.dart';
import 'package:ledge/core/errors/exceptions.dart';
import 'package:ledge/core/errors/failure.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ledge/features/auth/domain/entities/user.dart';
import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import 'package:ledge/utils/typedef.dart';

/// Now in our case when using right left i.e. Either we have to remember to return in RepoImpl based on the response
/// we are getting from RemoteDataSource In RepoImpl it should be try { implementation } on xyzException (which will be coming from remote ds in case of failure) { implementation }


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
      /// if any error we will throw Server Failure
      /// now we can return like below also but as this will be used more often we have created a reusable constructor where we just have to pass exception
      // return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final res = await _remoteDataSource.getUsers();
      return Right(res); /// we are returning this because if not Failure we will list of users from remote
    } on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }
}
