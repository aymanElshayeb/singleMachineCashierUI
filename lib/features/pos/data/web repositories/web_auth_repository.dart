import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart' as model;
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WebAuthRepository implements BaseAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;
  WebAuthRepository({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? auth,
    FirebaseFirestore? firebaseFirestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  @override
  EitherUser<model.User> googleSignInUser() async {
    debugPrint('Web-google sign in!');
    await _googleSignIn.signOut();
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      final UserCredential userCredential =
          await _auth.signInWithPopup(authProvider);
      if (userCredential.user != null) {
        bool? accessValue = await checkSystemAccess(
            userCredential.user!.email!, 'POS');
        if (accessValue == true) {
          model.User? user = await getUserByEmail(userCredential.user!.email!);
          if (user != null) {
            return right(user);
          } else {
            return left('User is not found');
          }
        } else if (accessValue == false) {
          return left(
              'the user: ${userCredential.user!.email!} does not have access for this system');
        } else {
          return left('User is not found');
        }
      }
      {
        // Google sign-in canceled by the user
        return left('user cancelled authentication');
      }
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherUser<String> signOutUser() async {
    try {
      _googleSignIn.signOut();
      _auth.signOut();
      return right('signed out successfully');
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  Future<model.User?> getUserByEmail(String email) async {
    try {
      // Perform the query to get the document(s) with the specified email
      final query = _firebaseFirestore
          .collection('users')
          .where('user.email', isEqualTo: email);
      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document found (assuming email is unique)
        final document = querySnapshot.docs.first;
        return model.User.fireBaseFromSnapshot(document);
      }

      // Return null if the email or "user" field is missing
      return null;
    } catch (e) {
      // Handle any errors that may occur during the query or data retrieval
      debugPrint('Error fetching user by email: $e');
      return null;
    }
  }

  Future<bool?> checkSystemAccess(String email, String accessKey) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection('users')
            .where('user.email', isEqualTo: email)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document found (assuming email is unique)
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          querySnapshot.docs.first;

      // Check if the "user" field exists and is a map
      if (documentSnapshot.data()!.containsKey('user') &&
          documentSnapshot.data()!['user'] is Map) {
        final Map<String, dynamic> userMap = documentSnapshot.data()!['user'];

        // Check if the "systemAccess" field exists and is a map
        if (userMap.containsKey('systemAccess') &&
            userMap['systemAccess'] is Map) {
          final Map<String, dynamic> systemAccessMap = userMap['systemAccess'];

          // Check if the accessKey exists in the "systemAccess" map and return its value
          if (systemAccessMap.containsKey(accessKey) &&
              systemAccessMap[accessKey] is bool) {
            return systemAccessMap[accessKey];
          }
        }
      }
    }

    // Return null if the email, "user", or "systemAccess" fields are missing,
    // or if the accessKey is not found in the "systemAccess" map.
    return null;
  }

  @override
  EitherUser<model.User> emailSignInUser(String email, String password) {
    // TODO: implement emailSignInUser
    throw UnimplementedError();
  }
}
