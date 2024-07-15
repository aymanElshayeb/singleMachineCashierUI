import 'package:dartz/dartz.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:firedart/firestore/firestore.dart';

class FireDartItemsDataSource implements ItemsDataSource {
    final Firestore _firebaseFirestore;

  FireDartItemsDataSource({
    Firestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? Firestore('pos-system-fe6f1');

  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(
      {String? categoryId}) async {
    List<Item> items = [];
    List<Item> categoryItems = [];
    try {
      var snapshot = await _firebaseFirestore.collection('items').get();

      items = snapshot.map((doc) => Item.fromSnapshot(doc)).toList();

      if (categoryId != null) {
        for (var item in items) {
          if (item.categoryId == categoryId) {
            categoryItems.add(item);
          }
        }

        return right(categoryItems);
      }

      return right(items);
    } catch (e) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getItemsByEan(
      {required String keyWord}) async {
    List<Item> items = [];
    List<Item> categoryItems = [];
    try {
      var snapshot = await _firebaseFirestore.collection('items').get();

      items = snapshot.map((doc) => Item.fromSnapshot(doc)).toList();

      for (var item in items) {
        if (item.PLU_EAN.contains(keyWord)) {
          categoryItems.add(item);
        }
      }

      return right(categoryItems);
    } catch (e) {
      return left(CacheFailure());
    }
  }

}