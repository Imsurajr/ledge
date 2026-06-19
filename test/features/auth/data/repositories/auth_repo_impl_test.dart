import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledge/core/errors/exceptions.dart';
import 'package:ledge/core/errors/failure.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ledge/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:mocktail/mocktail.dart';

/*
So we will be asking 3 questions first:
   Q1 What does the class depend on, something that we take in constructor and use - in this case yes on AuthRemoteDataSource
   Q2 How can we create a fake/mock version of the dependency - we will create a MockAuthRemoteDataSource using MockTail
   Q3 How do we control what our dependency do - using MockTail Apis
 */

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repoImpl;

  // creating constant server exception which we are expecting from server in failed case
  const tException = ServerException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
  });

  group('Tests for createUser', () {
    // use of these constants explained below
    const createdAt = 'test.createdAt';
    const name = 'test.name';
    const avatar = 'test.avatar';

    test(
      'Should always call [AuthRemoteDataSource.createUser] with the right data and complete successfully when the call to the remote data source is successful]',
      () async {
        // Arrange
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer(
          (_) async => Future.value(),
        ); // the return type is not either or so we are using Future.value(), we will not use null here coz we wanna test success case of remote ds

        // now here we be using the constant stings these strings because in order for the test to pass we should be giving same input
        /*
                const createdAt = 'test.createdAt';
                const name = 'test.name';
                const avatar = 'test.avatar';
         */

        // Act
        final res = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // Assert
        expect(res, equals(const Right(null)));
        // check the remoteDataSource's createUser gets called and with the right data
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'Should return a [ServerFailure] when the call to remote data source is Unsuccessful',
      () async {
        // Arrange
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(
          // here we are expecting it to throw an exception
          tException,
        );

        // Act
        final res = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // Assert
        expect(
          res,
          equals(
            // left because we are expecting the server failure
            // we will be passing same tException's ServerException message and status code as they should in repo and what server responds
            Left(
              ServerFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );

        // we will make sure no matter if the request is successful or not it calls remote data source
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);

        // at the end there should not be any more interactions with the datasource
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
