import '../../../utils/typedef.dart';
import '../domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();
  ResultFuture<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}
