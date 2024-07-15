import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';

import '../../domain/entities/category.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;


abstract class CategoryDataSource {
  Future<Either<Failure, List<Category>>> getCategories();
}

abstract class ItemsDataSource {
   Future<Either<Failure, List<Item>>> getCategoryItems({String? categoryId});
   Future<Either<Failure, List<Item>>> getItemsByEan({required String keyWord});
}

abstract class OrderDataSource {
  Future<Either<Failure, void>> saveOrder(entity.Order order);
  Future<Either<Failure, String>> createInvoice(entity.Order order);
}