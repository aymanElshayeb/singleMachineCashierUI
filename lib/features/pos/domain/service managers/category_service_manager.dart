import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:single_machine_cashier_ui/features/pos/data/offline%20repositories/category_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/category_repository.dart';


class CategoryServiceManager {
  static CategoryServiceManager? _instance;
  final CategoryRepository _categoryRepository;

  // Factory constructor with parameters
  factory CategoryServiceManager({FirebaseFirestore? firebaseFirestore,Firestore? firestore}) {
    return _instance ??= CategoryServiceManager._internal(firebaseFirestore: firebaseFirestore,firestore: firestore);
  }

  // The internal constructor takes parameters and passes them to the repository
  CategoryServiceManager._internal({FirebaseFirestore? firebaseFirestore,Firestore? firestore})
      : _categoryRepository = OfflineCategoryRepository();

  CategoryRepository get categoryRepository => _categoryRepository;
}
