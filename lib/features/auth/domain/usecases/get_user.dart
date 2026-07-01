import 'package:ledge/core/usecase/usecase.dart';
import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import '../../../../utils/typedef.dart';
import '../entities/user.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  const GetUsers(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<List<User>> call() async => _repo.getUsers();
}
