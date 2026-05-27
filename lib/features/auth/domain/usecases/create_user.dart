import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import 'package:ledge/utils/typedef.dart';

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
