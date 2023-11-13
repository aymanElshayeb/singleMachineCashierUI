import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/service%20managers/category_service_manager.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class Categories {
  final CategoryRepository repository;

  Categories({required CategoryServiceManager categoryServiceManager})
      : repository = categoryServiceManager.categoryRepository;
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    return await repository.getCategories();
  }
}
