import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:single_machine_cashier_ui/features/pos/data/repositories/auth_repository_impl.dart';
import 'package:single_machine_cashier_ui/features/pos/data/web%20repositories/web_auth_repository.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/auth_repository.dart';


class AuthServiceManager {
  static AuthServiceManager? _instance;
  final BaseAuthRepository _authRepository;

  // Factory constructor with parameters
  factory AuthServiceManager(
      {FirebaseFirestore? firebaseFirestore,
      Firestore? firestore,
      String? authProjectId,
      String? dataProjectId}) {
    return _instance ??= AuthServiceManager._internal(
        firebaseFirestore: firebaseFirestore,
        firestore: firestore,
        authProjectId: authProjectId,
        dataProjectId: dataProjectId);
  }

  // The internal constructor takes parameters and passes them to the repository
  AuthServiceManager._internal(
      {FirebaseFirestore? firebaseFirestore,
      Firestore? firestore,
      String? authProjectId,
      String? dataProjectId})
      : _authRepository = kIsWeb
            ? WebAuthRepository(firebaseFirestore: firebaseFirestore)
            : FiredartAuthRepository(
                authFirebaseFireStore: firestore,
                authProjectId: authProjectId!,
                );

  BaseAuthRepository get authRepository => _authRepository;
}
