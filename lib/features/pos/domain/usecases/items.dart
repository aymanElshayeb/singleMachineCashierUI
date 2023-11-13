import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/service%20managers/item_service_manager.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';

class Items {
  final ItemsRepository repository;

  Items({required ItemServiceManager itemServiceManager})
      : repository = itemServiceManager.itemRepository;

  Future<Either<Failure, List<Item>>> getItemsByCategory(
      {String? categoryId}) async {
    return await repository.getCategoryItems(categoryId: categoryId);
  }

  Future<Either<Failure, List<Item>>> getItemsByEan(
      {required String keyWord}) async {
    return await repository.getItemsByEan(keyWord: keyWord);
  }
}
