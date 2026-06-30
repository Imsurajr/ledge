part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
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
  const UsersLoadedState(this.users);

  final List<User> users;

  @override
  List<Object> get props => users.map((users) => users.id).toList();
}

final class AuthErrorState extends AuthState {
  const AuthErrorState(this.message);
  final String message;

  @override
  List<String> get props => [message];
}
