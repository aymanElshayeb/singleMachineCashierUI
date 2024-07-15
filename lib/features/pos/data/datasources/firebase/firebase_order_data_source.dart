import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart'
    as entity;

class FireBaseOrderDataSource implements OrderDataSource {
  @override
  Future<Either<Failure, String>> createInvoice(entity.Order order) {
    // TODO: implement createInvoice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> saveOrder(entity.Order order) {
    // TODO: implement saveOrder
    throw UnimplementedError();
  }

}