import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:single_machine_cashier_ui/features/pos/data/offline%20repositories/item_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/item_repository.dart';

class ItemServiceManager {
  static ItemServiceManager? _instance;
  final ItemsRepository _itemRepository;

  // Factory constructor with parameters
  factory ItemServiceManager(
      {FirebaseFirestore? firebaseFirestore, Firestore? firestore}) {
    return _instance ??= ItemServiceManager._internal(
        firebaseFirestore: firebaseFirestore, firestore: firestore);
  }

  // The internal constructor takes parameters and passes them to the repository
  ItemServiceManager._internal(
      {FirebaseFirestore? firebaseFirestore, Firestore? firestore})
      : _itemRepository = OfflineItemRepository();

  ItemsRepository get itemRepository => _itemRepository;
}
