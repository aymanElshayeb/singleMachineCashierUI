import 'package:dartz/dartz.dart';
import 'package:firedart/firedart.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;
class FireDartOrderDataSource implements  OrderDataSource {
   final Firestore _firebaseFirestore;

  FireDartOrderDataSource({
    Firestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? Firestore('pos-system-fe6f1');

  @override
  Future<Either<Failure, void>> saveOrder(
      entity.Order order) async {
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
  Future<Either<Failure, String>> createInvoice(entity.Order order) {
    // TODO: implement createInvoice
    throw UnimplementedError();
  }

}