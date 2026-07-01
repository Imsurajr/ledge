part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  /// in all the parent state we will have this
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  /// all the states will have this const constructor
  const AuthInitial();
}

final class CreatingUserState extends AuthState {
  const CreatingUserState();
}

final class UserCreatedState extends AuthState {
  const UserCreatedState();
}

final class GettingUsersState extends AuthState {
  const GettingUsersState();
}

final class UsersLoadedState extends AuthState {
  /// when the state have expected params then we will be using equatable props
  const UsersLoadedState(this.users);

  final List<User> users;

  /// here we are creating a new list of user.ids for checking unique users
  @override
  List<Object> get props => users.map((users) => users.id).toList();
}

final class AuthErrorState extends AuthState {
  const AuthErrorState(this.message);
  final String message;

  @override
  List<String> get props => [message];
}
