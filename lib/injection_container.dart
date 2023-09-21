import 'package:get_it/get_it.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/item_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/order_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/item_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/items.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/orders.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/auth/auth_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/bloc/ean_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/item/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'features/pos/data/datasources/category_local_data_source.dart';
import 'features/pos/data/datasources/item_local_data_source.dart';
import 'features/pos/data/datasources/user_local_data_source.dart';
import 'features/pos/data/repositories/category_repository_impl.dart';
import 'features/pos/data/repositories/user_repository_impl.dart';
import 'features/pos/domain/repositories/category_repository.dart';
import 'features/pos/domain/repositories/user_repository.dart';
import 'features/pos/domain/usecases/authenticate_user.dart';
import 'features/pos/domain/usecases/categories.dart';
import 'features/pos/presentation/bloc/categories/category_bloc.dart';
import 'features/pos/presentation/bloc/user/user_bloc.dart';

//service locator
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => UserBloc(authenticateUser: sl()));
  sl.registerFactory(() => OrderBloc(orders: sl()));
  sl.registerFactory(() => CategoryBloc(categories: sl()));
  sl.registerFactory(() => ItemBloc(items: sl()));
  sl.registerFactory(() => EanBloc(items: sl()));

  // Use cases
  sl.registerLazySingleton(() => AuthenticateUser(sl()));

  sl.registerLazySingleton(() => Categories(sl()));

  sl.registerLazySingleton(() => Items(sl()));

  sl.registerLazySingleton(() => Orders(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ItemsRepository>(
    () => ItemRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(),
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
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(),
  );

  //! Core

  //! External
}
