import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart' as entity;
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/service%20managers/order_service_manager.dart';

class Orders {
  final OrderRepository repository;

  Orders({required OrderServiceManager orderServiceManager})
      : repository = orderServiceManager.orderRepository;

  Future<Either<Failure, void>> saveOrder({
    required entity.Order order
  }) async =>
      await repository.saveOrder(
        order
      );

  Future<Either<Failure, String>> createInvoice({
    required entity.Order order
  }) async =>
      await repository.createInvoice(order);
}
