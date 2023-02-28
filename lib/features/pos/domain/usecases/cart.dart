import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/cart.dart';
import '../entities/cart.dart';
import '../entities/item.dart';
import '../repositories/cart_repository.dart';
import '../repositories/item_repository.dart';

class CartActions {
  final CartRepository repository;

  CartActions(this.repository);

  Future<Either<Failure, Cart>> getCart() async {
    return await repository.getCart();
  }

  Future<Either<Failure, Cart>> addItems(Item item, num quantity) async {
    return await repository.addItems(item, quantity);
  }

  Future<Either<Failure, Cart>> removeItem(Item item) async {
    return await repository.removeItem(item);
  }

  Future<Either<Failure, double>> getTotalPrice() async {
    return await repository.getTotalPrice();
  }
}
