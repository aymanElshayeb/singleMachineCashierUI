import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';

import '../../domain/repositories/category_repository.dart';

import '../datasources/category_local_data_source.dart';

import 'package:meta/meta.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl(
      {@required this.localDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
    } else {
      try {
        List<Category> categories = await localDataSource.getCategories();

        return Right(categories);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
