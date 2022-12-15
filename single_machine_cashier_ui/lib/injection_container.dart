import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/pos/data/datasources/user_local_data_source.dart';
import 'features/pos/data/repositories/user_repository_impl.dart';
import 'features/pos/domain/repositories/user_repository.dart';
import 'features/pos/domain/usecases/authenticate_user.dart';
import 'features/pos/presentation/bloc/user_bloc.dart';

//service locator
final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(
        () => UserBloc(authenticateUser: sl())
  );

  // Use cases
  sl.registerLazySingleton(() => AuthenticateUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
