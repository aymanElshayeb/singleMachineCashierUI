import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:dartz/dartz.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> addItems(Item item, num quantity);
  Future<Either<Failure, Cart>> removeItem(Item item);
  Future<Either<Failure, num>> getTotalPrice();
}
