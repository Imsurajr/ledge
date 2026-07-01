import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ledge/features/auth/domain/entities/user.dart';
import 'package:ledge/features/auth/domain/usecases/create_user.dart';
import 'package:ledge/features/auth/domain/usecases/get_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required CreateUser createUser, required GetUsers getUsers})
    : _createUser = createUser,
      _getUsers = getUsers,
      super(AuthInitial());

  /// dependencies same as bloc
  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> createUser({
    /// only difference between an bloc and an cubit is that bloc has events and cubit takes args using method signature
    required createdAt,
    required name,
    required avatar,
  }) async {
    /// content same as bloc
    emit(const CreatingUserState());
    final res = await _createUser(
      CreateUserParams(createdAt: createdAt, name: name, avatar: avatar),
    );
    res.fold(
      (failure) => emit(AuthErrorState(failure.errorMessage)),
      (_) => emit(UserCreatedState()),
    );
  }

  Future<void> getUsers() async {
    emit(const GettingUsersState());
    final res = await _getUsers();
    res.fold(
      (failure) => emit(AuthErrorState(failure.errorMessage)),
      (users) => emit(UsersLoadedState(users)),
    );
  }
}
