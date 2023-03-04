import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/cart.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/item_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../datasources/user_local_data_source.dart';
import 'package:meta/meta.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, Cart>> addItems(Item item, num quantity) async {
    try {
      Cart cart = await localDataSource.addItems(item, quantity);
      return Right(cart);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      //final cart = await localDataSource.getCart();

      return Right(
          Cart(items: [Item(name: 'aaaaaa', price: 20)], quantities: [1]));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, num>> getTotalPrice() async {
    try {
      num total = 0;
      final cart = await localDataSource.getCart();

      for (var item in cart.items) {
        total += item.price;
      }
      for (int i = 0; i < cart.items.length; i++) {
        total += cart.items[i].price * cart.quantities[i];
      }
      return Right(total);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> removeItem(Item item) async {
    try {
      final cart = await localDataSource.getCart();
      for (int i = 0; i < cart.items.length; i++) {
        if (cart.items.contains(item)) {
          cart.items.remove(item);
          cart.quantities.removeAt(i);
        }
      }
      return Right(cart);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
