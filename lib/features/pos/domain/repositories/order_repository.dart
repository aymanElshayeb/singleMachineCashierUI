import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart' as entity;

import '../../../../core/error/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, void>> saveOrder(
    double orderPrice,
    entity.PaymentMethod paymentMethod,
  );
  Future<Either<Failure, String>> createInvoice(
      entity.Order order, );
}
