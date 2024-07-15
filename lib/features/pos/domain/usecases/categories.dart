import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class Categories {
  final CategoryRepository repository;

  Categories({required this.repository});
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    return await repository.getCategories();
  }
}
