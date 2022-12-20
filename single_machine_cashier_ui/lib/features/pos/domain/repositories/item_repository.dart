import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class ItemsRepository {
  Future<Either<Failure, Item>> getCategoryItems(int category);
  Future<Either<Failure, Item>> getAllItems();
  Future<Either<Failure, Item>> getItem(int id);

}
