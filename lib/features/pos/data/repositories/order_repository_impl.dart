import 'package:dartz/dartz.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';

class FiredartOrderRepositoryImpl implements OrderRepository {
  final Firestore _firebaseFirestore;

  FiredartOrderRepositoryImpl({
    Firestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? Firestore('pos-system-fe6f1');

  @override
  Future<Either<Failure, void>> saveOrder(
      double orderPrice, entity.PaymentMethod paymentMethod) async {
    entity.Order order = entity.Order(
        totalPrice: orderPrice,
        paymentMethod: paymentMethod,
        dateTime: DateTime.now());
    try {
      await _firebaseFirestore
          .collection('orders')
          .add({'order': order.toMap()});
      return right(null);
    } catch (e) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createInvoice(List<Item> orderItems) {
    // TODO: implement createInvoice
    throw UnimplementedError();
  }
}
