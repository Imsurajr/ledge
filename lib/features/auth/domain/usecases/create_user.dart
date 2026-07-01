import 'package:equatable/equatable.dart';
import 'package:ledge/core/usecase/usecase.dart';
import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import 'package:ledge/utils/typedef.dart';

/// now we are using the custom Usecase which we defined, we are moving from this

/*
class CreateUser {
  const CreateUser(this._repo);
  final AuthRepo _repo;

  // so we created a instance of repo and then when the usecase got the required info those are passed to _repo.createUser
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async =>
      _repo.createUser(createdAt: createdAt, name: name, avatar: avatar);
}
 */

/// to this
class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  // passing custom params class as there are more than one params
  const CreateUser(this._repo);
  final AuthRepo _repo;

  @override
  ResultVoid call (CreateUserParams params) async => _repo.createUser(
    createdAt: params.createdAt,
    name: params.name,
    avatar: params.avatar,
  );
}

/// this class will be used to define all the params that we want to pass to the usecase
class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  /// this we are creating for reusability for testing and other for not passing the empty params again and again
  const CreateUserParams.empty() :
   this(createdAt: '_empty.createdAt', name: '_empty.name', avatar : '_empty.avatar');

  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
