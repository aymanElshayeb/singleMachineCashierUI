import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/item.dart';

abstract class ItemsRepository {
  Future<Either<Failure, List<Item>>> getCategoryItems({String? categoryId});
  Future<Either<Failure, List<Item>>> getItemsByEan({required String keyWord});
}
