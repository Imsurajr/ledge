part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  /// creating props with equatable in parent class to manage recurring creation for non parametric classes
  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthEvent {
  const CreateUserEvent({required this.createdAt, required this.name, required this.avatar});
  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object> get props => [createdAt, name, avatar];
}

class GetUsersEvent extends AuthEvent {
  const GetUsersEvent();
  /// now here we will not be having any props for equatable as this class is not taking any params
}
