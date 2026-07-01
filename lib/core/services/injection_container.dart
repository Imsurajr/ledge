import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ledge/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:ledge/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:ledge/features/auth/domain/repositories/auth_repo.dart';
import 'package:ledge/features/auth/domain/usecases/create_user.dart';
import 'package:ledge/features/auth/domain/usecases/get_user.dart';
import 'package:ledge/features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

/// this will be used to initialize any dependency
Future<void> init() async {
  /// for registering the base/first we use factory, for dependencies will use lazySingleton
  // App Logic
  sl.registerFactory(() => AuthCubit(createUser: sl(), getUsers: sl()));

  // Usecases
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));

  // this means whenever someone is looking for [AuthRepo] give them [AuthRepoImpl]
  // so for eg when we do this in usecase
  //   const CreateUser(this._repo);
  //   final AuthRepo _repo;
  // it actually will pass [AuthRepoImpl}

  // Repositories
  sl.registerLazySingleton<AuthRepo>(()=>AuthRepoImpl(sl()));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(()=>AuthRemoteDataSourceImpl(sl()));
  /// these dependencies are written in the reverse order of their dependencies so we were passing sl innit and the final
  /// one is depends on external dependency so we will pass it like we did here

  // External Dependencies
  sl.registerLazySingleton(() => http.Client()); // we can also write http.Client.new which will also create a new instance for this class

  /// there's one more way to write this as we have to do sl. sl. again and again we can just use Cascade Operator(..) and do sl..xyz.. abc like that
}
