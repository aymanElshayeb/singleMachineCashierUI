import 'package:dartz/dartz.dart';
import 'package:firedart/firestore/firestore.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/item_local_data_source.dart';

class ItemRepositoryImpl implements ItemsRepository {
  final ItemLocalDataSource localDataSource;
  final Firestore _firebaseFirestore;

  ItemRepositoryImpl({
    required this.localDataSource,
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
