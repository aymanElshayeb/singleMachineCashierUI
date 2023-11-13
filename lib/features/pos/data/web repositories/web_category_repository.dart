import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class WebCategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  WebCategoryRepositoryImpl({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    List<Category> categories = [];
    try {
      var snapshot = await _firebaseFirestore.collection('categories').get();

      categories = snapshot.docs.map((doc) => Category.fireBaseFromSnapshot(doc)).toList();
      return right(categories);
    } catch (e) {
      return left(CacheFailure());
    }
  }
}
