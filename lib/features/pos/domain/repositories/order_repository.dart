import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart';

import '../../../../core/error/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, void>> saveOrder(
    double orderPrice,
    PaymentMethod paymentMethod,
  );
  Future<Either<Failure, String>> createInvoice(
      List<Item> orderItems, );
}
