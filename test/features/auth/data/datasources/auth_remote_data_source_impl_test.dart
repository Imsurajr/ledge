import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ledge/core/errors/exceptions.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:ledge/features/auth/data/models/user_model.dart';
import 'package:ledge/utils/constants.dart';
import 'package:mocktail/mocktail.dart';

/* So we wanna ask these questions before writing any test
   Q1 What does the class depend on, something that we take in constructor and use - in this case yes on Http Clientk
   Q2 How can we create a fake/mock version of the dependency - we will create a MockAuthRepo using MockTail
   Q3 How do we control what our dependency do - using MockTail Apis
 */

/// Here we can see that we can Mock the classes even from external libraries it need not to be user defined
class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });

  const String createdAt = 'createdAt';
  const String name = 'name';
  const String avatar = 'avatar';

  group('createUser', () {
    test('Should complete successfully when status code is 200 or 201', () async {
      await dotenv.load(fileName: ".env");
      // Arrange
      /// here what it means is we are asking client if an http post request is sent to any url
      /// with any body then intercept it and return mock success response
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => http.Response('User Created Successfully', 201),
      );

      // Act
      final methodCall = remoteDataSource.createUser;

      // Assert
      /// one more way to write expect we want the request to be completed
      /// we are doing like this because the createUser does not return anything
      expect(
        /// here we did not use ()=> invocation at start because in this case we were invocking it in order to check its value
        /// to make sure it completes successfully
        methodCall(createdAt: createdAt, name: name, avatar: avatar),
        completes,
      );

      /// so here we are making sure that
      verify(
        /// the client got called
        () => client.post(
          /// the client got called at the correct uri
          // Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
          Uri.https(kBaseUrl!, kCreateUserEndpoint),

          /// the client got called with the correct data
          body: jsonEncode({
            'createdAt': createdAt,
            'name': name,
            'avatar': avatar,
          }),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test(
      'Should throw an [ServerException] when the request to server is not successful with a proper message',
      () async {
        //  Arrange
        /// we've used theAnswer below and not thenThrow because the server won't be throwing any error instead it will be
        /// returning the response but with a different status code(400)
        when(
          () => client.post(any(), body: any(named: 'body')),
        ).thenAnswer((_) async => http.Response('Invalid Email Address', 400));

        // Act
        final methodCall = remoteDataSource.createUser;
        expect(
          methodCall(createdAt: createdAt, name: name, avatar: avatar),
          throwsA(
            ServerException(message: 'Invalid Email Address', statusCode: 400),
          ),
        );

        // Assert
        /// so here we are making sure that
        verify(
          /// the client got called
          () => client.post(
            /// the client got called at the correct uri
            // Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
            Uri.https(kBaseUrl!, kCreateUserEndpoint),

            /// the client got called with the correct data
            body: jsonEncode({
              'createdAt': createdAt,
              'name': name,
              'avatar': avatar,
            }),
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });

  group('getUsers', () {
    const tRes = [UserModel.empty()];
    const String tMessage = 'Server Error';
    test('Should return a [List<UserModel] when the status code is 200 ', () async {
      await dotenv.load(fileName: ".env");

      // Arrange
      when(() => client.get(any())).thenAnswer(
        // (_) async => http.Response('Users fetched successfully', 200),
        /// here (tRes.first.toMap) takes dart (UserModel) and turns into dart Map, ([...]) wraps Map into List
        /// because endpoint returns list, (jsonEncode(...)) takes that list and make it a String
        (_) async => http.Response((jsonEncode([tRes.first.toMap()])), 200),
      );

      // Act
      final res = await remoteDataSource.getUsers();
      expect(res, equals(tRes));

      // Assert
      verify(
        // () => client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint')),
        /// here we are just verifying that the call is made as get and through https to our base url and get endpoint
        () => client.get(Uri.https(kBaseUrl!, kGetUsersEndpoint)),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test(
      'Should throw an [ServerException] when the status code is not 200k',
      () async {
        await dotenv.load(fileName: ".env");
        // Arrange
        when(
          () => client.get(any()),
        ).thenAnswer((_) async => http.Response(tMessage, 500));

        // Act
        final methodCall = remoteDataSource.getUsers;
        expect(
          () => methodCall(),
          throwsA(const ServerException(message: tMessage, statusCode: 500)),
        );

        // Assert
        verify(
          () => client.get(Uri.https(kBaseUrl!, kGetUsersEndpoint)),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });
}
