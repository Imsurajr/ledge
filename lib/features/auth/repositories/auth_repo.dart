import '../../../utils/typedef.dart';
import '../domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();
  // using typedef for void which inturn is a typedef of ResultFuture with void
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  // using typedef for maintainability
  ResultFuture<List<User>> getUsers();
}
