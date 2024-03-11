import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/service%20managers/order_service_manager.dart';

class Orders {
  final OrderRepository repository;

  Orders({required OrderServiceManager orderServiceManager})
      : repository = orderServiceManager.orderRepository;

  Future<Either<Failure, void>> saveOrder({
    required double orderPrice,
    required PaymentMethod paymentMethod,
  }) async =>
      await repository.saveOrder(
        orderPrice,
        paymentMethod,
      );

  Future<Either<Failure, String>> createInvoice({
    required List<Item> orderItems,
  }) async =>
      await repository.createInvoice(orderItems);
}
