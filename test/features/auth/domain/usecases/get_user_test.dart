import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledge/features/auth/domain/entities/user.dart';
import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import 'package:ledge/features/auth/domain/usecases/get_user.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repo.mock.dart';

/* So we wanna ask these questions before writing any test
   Q1 What does the class depend on
   Q2 How can we create a fake/mock version of the dependency
   Q3 How do we control what our dependency do
 */


void main() {
  late AuthRepo repo;
  late GetUsers usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = GetUsers(repo);
  });

  const tRes = [User.empty()];

  test('Should always call [AuthRepo.getUsers] and return [List<User>]', () async {
    /// Arrange
    when(() => repo.getUsers()).thenAnswer((_) async => Right(tRes),
    );

    /// Act
    final res = await usecase();

    /// Assert
    expect(res, Right<dynamic, List<User>>(tRes));
    verify(() => repo.getUsers()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
