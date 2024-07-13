import 'package:dartz/dartz.dart';
import 'package:firedart/firestore/firestore.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class FiredartCategoryRepositoryImpl implements CategoryRepository {
  final Firestore _firebaseFirestore;

  FiredartCategoryRepositoryImpl({
    Firestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? Firestore('pos-system-fe6f1');

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    List<Category> categories = [];
    try {
      var snapshot = await _firebaseFirestore.collection('categories').get();

      categories = snapshot.map((doc) => Category.fromSnapshot(doc)).toList();
      return right(categories);
    } catch (e) {
      return left(CacheFailure());
    }
  }
}
