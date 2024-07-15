import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource nodeDataSource;
  final OrderDataSource fireBaseDataSource;
  final OrderDataSource fireDartDataSource;
  final OrderDataSource odooDataSource;

  OrderRepositoryImpl(
      {required this.nodeDataSource,
      required this.fireBaseDataSource,
      required this.fireDartDataSource,
      required this.odooDataSource});
  @override
  Future<Either<Failure, String>> createInvoice(entity.Order order) {
    const type = String.fromEnvironment('DATA_SOURCE');
    switch (type) {
      case 'node':
        return nodeDataSource.createInvoice(order);
      case 'firebase':
        return fireBaseDataSource.createInvoice(order);
      case 'firedart':
        return fireDartDataSource.createInvoice(order);
      case 'odoo':
        return odooDataSource.createInvoice(order);
      default:
        throw CacheFailure();
    }
  }

  @override
  Future<Either<Failure, void>> saveOrder(entity.Order order) {
    const type = String.fromEnvironment('DATA_SOURCE');
    switch (type) {
      case 'node':
        return nodeDataSource.saveOrder(order);
      case 'firebase':
        return fireBaseDataSource.saveOrder(order);
      case 'firedart':
        return fireDartDataSource.saveOrder(order);
      case 'odoo':
        return odooDataSource.saveOrder(order);
      default:
        throw CacheFailure();
    }
  }
}
