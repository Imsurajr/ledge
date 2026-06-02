import '../../../../utils/typedef.dart';
import '../entities/user.dart';

/// here we define how we want to communicate with our data layer
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
