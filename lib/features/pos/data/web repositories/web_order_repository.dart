import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';

class WebOrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  WebOrderRepositoryImpl({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> saveOrder(
      double orderPrice, entity.PaymentMethod paymentMethod) async {
    
    try {
      await _firebaseFirestore
          .collection('orders')
          .add({'order': {
          'orderPrice':orderPrice,
          'paymentMethod':paymentMethod,
          'dateTime':DateTime.now()
        }});
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
