import 'package:get_it/get_it.dart';

import 'features/pos/data/datasources/category_local_data_source.dart';
import 'features/pos/data/datasources/item_local_data_source.dart';
import 'features/pos/data/datasources/user_local_data_source.dart';
import 'features/pos/data/repositories/category_repository_impl.dart';
import 'features/pos/data/repositories/user_repository_impl.dart';
import 'features/pos/domain/repositories/category_repository.dart';
import 'features/pos/domain/repositories/user_repository.dart';
import 'features/pos/domain/usecases/authenticate_user.dart';
import 'features/pos/domain/usecases/categories.dart';
import 'features/pos/presentation/bloc/cart/cart_bloc.dart';
import 'features/pos/presentation/bloc/category/category_bloc.dart';
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
    ),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      localDataSource: sl(),
      itemLocalDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(),
  );

  //! Core

  //! External
}
