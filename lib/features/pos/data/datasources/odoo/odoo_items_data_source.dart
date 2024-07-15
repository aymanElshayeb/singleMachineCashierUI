import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';

class OdooItemsDataSource implements ItemsDataSource {
  @override
  Future<Either<Failure, List<Item>>> getCategoryItems({String? categoryId}) {
    // TODO: implement getCategoryItems
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Item>>> getItemsByEan({required String keyWord}) {
    // TODO: implement getItemsByEan
    throw UnimplementedError();
  }

}