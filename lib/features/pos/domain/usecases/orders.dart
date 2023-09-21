import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';

class Orders {
  final OrderRepository repository;

  Orders(this.repository);

  Future<Either<Failure, void>> saveOrder(
          {required double orderPrice,
          required PaymentMethod paymentMethod}) async =>
      await repository.saveOrder(orderPrice, paymentMethod);
}
