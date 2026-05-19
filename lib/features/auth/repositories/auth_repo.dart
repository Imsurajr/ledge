import '../../../utils/typedef.dart';
import '../domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();
  Future<ResultFuture<void>> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<ResultFuture<List<User>>> getUsers();
}
