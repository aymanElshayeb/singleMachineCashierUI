import 'package:dartz/dartz.dart';
import 'package:firedart/firedart.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/data/datasources/data_source.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/category.dart';

class FireDartCategoryDataSource implements CategoryDataSource {
  final Firestore _firebaseFirestore;

  FireDartCategoryDataSource({required Firestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? Firestore('pos-system-fe6f1');
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