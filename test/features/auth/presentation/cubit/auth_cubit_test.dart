import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledge/core/errors/failure.dart';
import 'package:ledge/features/auth/domain/usecases/create_user.dart';
import 'package:ledge/features/auth/domain/usecases/get_user.dart';
import 'package:ledge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

/* So we wanna ask these questions before writing any test
   Q1 What does the class depend on, something that we take in constructor and use - in this case yes on AuthUsecase
   Q2 How can we create a fake/mock version of the dependency - we will create a MockAuthUsecase using MockTail
   Q3 How do we control what our dependency do - using MockTail Apis
 */

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUsers extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthCubit cubit;

  /// we are creating this because when we pass the any() in cubit it'll expect the Usecase in args so we will create this fallback
  const tCreateUserParams = CreateUserParams.empty();
  const tServerFailure = ServerFailure(message: 'message', statusCode: 400);
  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUsers();
    cubit = AuthCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('Initial State Should be [AuthInitialState]', () async {
    /// for tests for cubit/bloc we won't be needing Arrange and Act as those parts are covered in class definition/event of them
    // Assert
    expect(cubit.state, const AuthInitial());
  });

  group('createUser', () {
    /// in the blocTest the first expected arg is the type of the bloc and then its state
    blocTest<AuthCubit, AuthState>(
      'Should emit [CreatingUserState, UserCreatedState] when successful',
      build:
          /// now here if we don't want to arrange we will directly return the cubit which we created above but if we wanna arrange
          () {
            // Arrange
            /// here the any will search for fallback as create user does not expect a generic type so our registered value will be used
            when(
              () => createUser(any()),
            ).thenAnswer((_) async => const Right(null));

            /// After we've stubbed above we always wants to return cubit so it build the next of the functionality
            /// this is when we are writing arrange if no arrange is there we will directly return cubit
            return cubit;
          },

      // Act
      /// this bloc test package follows principles of test which we learnt arrange, act and assert
      /// this is how it'll look for a cubit
      /// in bloc it'll look like this:
      /// act: (bloc) => bloc.add(CreateUserEvent(createdAt: 'createdAt', name: 'name', avatar: 'avatar') this is the difference
      /// between bloc and cubit's test
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,

        /// why the test with below params was passing even when they are diff from tCreateUserParams's params? reason below
        // createdAt: 'createdAt',
        // name: 'name',
        // avatar: 'avatar',
      ),

      // Assert
      /// here we are expecting a list of the states that we are expected to emit
      expect: () => const [CreatingUserState(), UserCreatedState()],

      /// here this was supposed to fail
      //         // createdAt: tCreateUserParams.createdAt,
      //         // name: tCreateUserParams.name,
      //         // avatar: tCreateUserParams.avatar,
      //         createdAt: 'createdAt',
      //         name: 'name',
      //         avatar: 'avatar',
      /// but it did not fail because we used :
      // verify: (_) => () {
      //         verify(() => createUser(tCreateUserParams)).called(1);
      //         verifyNoMoreInteractions(createUser);
      //       },
      /// and not verify: (_) {xyz}, reason :
      /// Notice the => () right after the underscore?
      // In Dart, this syntax means you are passing a function that returns another anonymous function.
      // When the blocTest package reaches the verify phase, it executes the outer function, which silently
      // returns your inner function and does absolutely nothing with it. Because the inner function never executes,
      // Mocktail never actually checks the parameters, and the test passes!
      verify: (_) {
        /// here we need to verify that the [createUser] usecase got called with actual params(createUser.empty()) which we wanted to pass
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'Should emit [CreatingUserState, AuthErrorState] when unsuccessful',

      /// this test will follow same principles like before but just for failures
      // Arrange
      build: () {
        when(
          () => createUser(any()),

          /// here we will be passing ServerFailure in the left
        ).thenAnswer((_) async => const Left(tServerFailure));
        return cubit;
      },

      // Act
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),

      // Assert
      expect: () => [
        CreatingUserState(),
        AuthErrorState(tServerFailure.errorMessage),
      ],

      verify: (_) => () {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  /// this will just follow the format of createUser which we wrote earlier
  group('getUsers', () {
    blocTest<AuthCubit, AuthState>(
      'Should emit [GettingUsersState, UserCreatedState] when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [GettingUsersState(), UsersLoadedState([])],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });

  blocTest<AuthCubit, AuthState>(
    'Should emit [GettingUsersState, AuthErrorState] when unsuccessful',
    build: () {
      when(
        () => getUsers(),
      ).thenAnswer((_) async => const Left(tServerFailure));
      return cubit;
    },
    act: (cubit) => cubit.getUsers(),
    expect: () => [
      const GettingUsersState(),
      AuthErrorState(tServerFailure.errorMessage),
    ],
    verify: (_) {
      verify(() => getUsers()).called(1);
      verifyNoMoreInteractions(getUsers);
    },
  );
}
