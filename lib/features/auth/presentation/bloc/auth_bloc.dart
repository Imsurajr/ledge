import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ledge/features/auth/domain/entities/user.dart';
import 'package:ledge/features/auth/domain/usecases/create_user.dart';
import 'package:ledge/features/auth/domain/usecases/get_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Now if we wanted to make private variables so as we cant take private vars in required we will take
  /// them normally along with initializing them too in constructor then will assign them to private vars
  AuthBloc({required CreateUser createUser, required GetUsers getUsers})
    : _createUser = createUser,
      _getUsers = getUsers,
      super(const AuthInitial()) {
    // on<AuthEvent>((event, emit) {
    /// this we will be using in case we gotta show something similar on all the Auth Events for example
    /// loading across createUser, getUser and all methods of AuthEvent so we will call it here
    // });
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const CreatingUserState());

    final res = await _createUser(
      CreateUserParams(
        createdAt: event.createdAt,
        name: event.name,
        avatar: event.avatar,
      ),
    ); // here we can also use _createUser.call()
    /// now since our repo impl can return one of Either Success or Failure we will be handling that in fold
    /// res.fold(ifLeft, ifRight)
    res.fold(
      /// so for left we are using failure as repo's left is failure
      (failure) => emit(
        /// we will emit Error State
        AuthErrorState(
          // now we've added this in failure class for reusability
          // '${failure.statusCode}'
          // 'Error: '
          // '${failure.message}',
          failure.errorMessage,
        ),
      ),

      /// for Right we no need to invoke anything we will just be passing User Created State
      (_) => emit(UserCreatedState()),
    );
  }

  Future<void> _getUsersHandler(
    GetUsersEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const GettingUsersState());
    final res = await _getUsers();
    res.fold(
      (failure) => emit(AuthErrorState(failure.errorMessage)),
      /// for Right here we will be getting the list of users which we will be emitting directly
      (users) => emit(UsersLoadedState(users)),
    );
  }
}
