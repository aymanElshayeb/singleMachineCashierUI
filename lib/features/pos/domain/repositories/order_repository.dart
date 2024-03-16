import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart' as entity;

import '../../../../core/error/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, void>> saveOrder(
    entity.Order order
  );
  Future<Either<Failure, String>> createInvoice(
      entity.Order order, );
}
