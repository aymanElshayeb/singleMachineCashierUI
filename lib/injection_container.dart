import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/category_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/categories.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/category/bloc.dart';
import 'core/network/network_info.dart';
import 'features/pos/data/datasources/category_local_data_source.dart';
import 'features/pos/data/datasources/item_local_data_source.dart';
import 'features/pos/data/datasources/user_local_data_source.dart';
import 'features/pos/data/repositories/category_repository_impl.dart';
import 'features/pos/data/repositories/user_repository_impl.dart';
import 'features/pos/domain/repositories/user_repository.dart';
import 'features/pos/domain/usecases/authenticate_user.dart';
import 'features/pos/presentation/bloc/user/user_bloc.dart';

//service locator
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => UserBloc(authenticateUser: sl()));

  sl.registerFactory(() => CategoryBloc(categories: sl()));
  // Use cases
  sl.registerLazySingleton(() => AuthenticateUser(sl()));

  sl.registerLazySingleton(() => Categories(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      itemLocalDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => InternetConnectionChecker());
}
