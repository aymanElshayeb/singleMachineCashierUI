import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:single_machine_cashier_ui/features/pos/data/offline%20repositories/offline_auth_repository.dart';
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
      : _authRepository = OfflineAuthRepository(secureStorage: const FlutterSecureStorage());

  BaseAuthRepository get authRepository => _authRepository;
}
