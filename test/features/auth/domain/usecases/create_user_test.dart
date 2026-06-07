import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import 'package:ledge/features/auth/domain/usecases/create_user.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

/* So we wanna ask these questions before writing any test
 Q1 What does the class depend on - in this case yes on AuthRepo
 Q2 How can we create a fake/mock version of the dependency - we will create a MockAuthRepo using MockTail
 Q3 How do we control what our dependency do - using MockTail Apis
 */

// It will be created like this we have created a reusable version so we are importing it class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  // now first we will create AuthRepo and CreateUser's instances as our test class depends on that
  late AuthRepo repo;
  late CreateUser usecase;

  // then we wanna right a setUp where we will direct the calls of the vars that we have declared
  setUp(() {
    repo = MockAuthRepo(); // we need to instantiate it because it will be used when we will instantiate usecase
    usecase = CreateUser(repo);
  });

  const Params = CreateUserParams.empty();
  test('Should always call the [AuthRepo.createUser]', () async {
    /*
       Arrange - so here we will arrange what that file on which we are dependent will return so basically we want to control
       the usecase but the usecase is actually dependent on something else in this case that is repository so we would like
       to control that repository as our usecase is dependent on that so we will like it like this:

       so the code block which we write inside Arrange is called STUBBING so we are basically hijacking the response of repo
       in our case
     */
    when(
      () => repo.createUser(
        createdAt: any(named: 'createdAt'),
        name: any(named: 'name'),
        avatar: any(named: 'avatar'),
      ),
      /*
       now here we are passing any() so for darts's generic object we can pass this any() when the datas are required
       and this will pass some mock information for testing to function, now if the datatype which we have to pass is not a
       generic datatype for eg if it is like a object of a
       class Football {}
       then we will have to register it just after declaring void main of testing like this :
       registerFallBackValue(Football());
       now after registering this, this basically means creating mock value for that class now if we have registered it then
       we can call any() and it will search among the values which we have registered and create a mock value for that

       now any() will work if it was a positional parameter but if the parameter accepted by the class that we are testing is
       named then we will need to pass name of that param just like we did in the when() which we declared

       now after calling the function then what? then we will use .then
       now there are 3 versions of then
       thenThrow() - this we will use when we want the function to throw an error,
       thenAnswer() - this we will use for the functions which are going to return at runtime, for the functions which are
       going to be async
       thenReturn() -  this we will use when the function is not async means we wont have to wait for it to return anything
       it's declaration will be done in compile time and wont be extended till runtime, if we dont want to wait for it in that case
       we will use this

       now inside then for our datatype we have either a failure or a success so generally failures are put in left and success is
       put in right like Either<Future<Failure, void>> so here as we are writing the test for the success case so we will use
       then.Answer((_) async => Right(// now in our case we are expecting a void so we will right a void here))
       so when we write
       then.Answer((_) async const Right(null))

       so this whole block means whenever someone calls createUser on the repo so we want to give them back a Right() answerk
      */
    ).thenAnswer((_) async => const Right(null));

    // Act
    final res = await usecase(Params); // await is important as we wanna verifyy the test else it will fail

    /* Assert : so here we actually wanna assert that the Arrange block has been ran or in our use here when the repo.createUser()
    gets called there it returns the Right() data and we also wanna test that it actually Calls which we wrote here

    test('Should always call the [AuthRepo.createUser]', so we wanna test that it actually calls the AuthRepo.createUser

    so in the Assert block we will write that we are expecting the usecase.createUser() to return a Right(null)
    {although it will return a void or Right(void) in case of success to be precise but as we wanna test it so we are expecting Right(null)
    right now so we will write it like this :

    now here
    expect(res, Right(null),);
    will also work but for best coding practices we are adding few more code to the Assert code block

    now after we write the expect code block we will verify that the usecase.CreateUser() is actually calling the Auth.CreateUser()
    so with verify(() => repo.createUser(createdAt: Params.createdAt, name: Params.name, avatar: Params.avatar),).called(1);
    we will verify the usecase.createUser() actually called repo.createUser and that too only once
    and at last we wanna verifyNoMoreInteractions(repo); and at the end we will check that there were no more interactions
     */
    expect(res, equals(Right<dynamic, void>(null)));
    // now for right we wanna write Right<Failure, void> as expected but with dynamic we wont have to import it everytime
    // and it works the same for left we will write Left<void, Failure> or Left<void, dynamic>

    verify(
      () => repo.createUser(
        createdAt: Params.createdAt,
        name: Params.name,
        avatar: Params.avatar,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
