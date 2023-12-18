import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:single_machine_cashier_ui/features/pos/data/offline%20repositories/order_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/order_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/web%20repositories/web_order_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/order_repository.dart';

class OrderServiceManager {
  static OrderServiceManager? _instance;
  final OrderRepository _orderRepository;

  // Factory constructor with parameters
  factory OrderServiceManager(
      {FirebaseFirestore? firebaseFirestore, Firestore? firestore}) {
    return _instance ??= OrderServiceManager._internal(
        firebaseFirestore: firebaseFirestore, firestore: firestore);
  }

  // The internal constructor takes parameters and passes them to the repository
  OrderServiceManager._internal(
      {FirebaseFirestore? firebaseFirestore, Firestore? firestore})
      : _orderRepository = OfflineOrderRepository();

  OrderRepository get orderRepository => _orderRepository;
}
