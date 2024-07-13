import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';

class WebItemRepositoryImpl implements ItemsRepository {
  final FirebaseFirestore _firebaseFirestore;

  WebItemRepositoryImpl({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<Item>>> getCategoryItems(
      {String? categoryId}) async {
    List<Item> items = [];
    List<Item> categoryItems = [];
    try {
      var snapshot = await _firebaseFirestore.collection('items').get();

      items = snapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList();

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

      items = snapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList();

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
