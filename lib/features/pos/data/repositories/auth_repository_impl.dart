import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _auth;
  final CollectionReference _firebaseFireStore2;

  AuthRepository({
    FirebaseAuth? auth,
    CollectionReference? firebaseFirestore,
    CollectionReference? firebaseFirestore2,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firebaseFireStore2 = firebaseFirestore2 ??
            Firestore('user-management-da458').collection('users');

  @override
  EitherUser<User> googleSignInUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Google sign-in successful
        // Retrieve the Google sign-in authentication details
        bool? accessValue = await checkSystemAccess(googleUser.email, 'POS');

        if (accessValue == true) {
          User? user = await getUserByEmail(googleUser.email);
          if (user != null) {
            return right(user);
          } else {
            return left('User is not found');
          }
        } else if (accessValue == false) {
          return left(
              'the user: ${googleUser.email} does not have access for this system');
        } else {
          return left('User is not found');
        }
      } else {
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
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      googleSignIn.signOut();
      _auth.signOut();
      return right('signed out successfully');
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

// Initialize Firestore instance

  Future<User?> getUserByEmail(String email) async {
    try {
      // Perform the query to get the document(s) with the specified email
      final query = _firebaseFireStore2.where('user.email', isEqualTo: email);

      final querySnapshot = await query.get();

      if (querySnapshot.isNotEmpty) {
        // Get the first document found (assuming email is unique)
        final document = querySnapshot.first;
        return User.fromSnapshot(document);
      }

      // Return null if the email or "user" field is missing
      return null;
    } catch (e) {
      // Handle any errors that may occur during the query or data retrieval
      debugPrint('Error fetching user by email: $e');
      return null;
    }
  }

  @override
  EitherUser<User> emailSignInUser(String email, String password) async {
    try {
      await _auth.signIn(email, password);

      User? currentUser = await getUserByEmail(email);
      print(currentUser!);

      return right(currentUser);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  Future<bool?> checkSystemAccess(String email, String accessKey) async {
    try {
      // Perform the query to get the document(s) with the specified email
      final query = _firebaseFireStore2.where('user.email', isEqualTo: email);
      final querySnapshot = await query.get();

      if (querySnapshot.isNotEmpty) {
        // Get the first document found (assuming email is unique)
        final document = querySnapshot.first;

        // Access the raw JSON data of the document as a Map
        final data = document.map;

        // Check if the "user" field exists and is a map
        if (data.containsKey('user') && data['user'] is Map) {
          final userMap = data['user'];

          // Check if the "systemAccess" field exists and is a map
          if (userMap.containsKey('systemAccess') &&
              userMap['systemAccess'] is Map) {
            final systemAccessMap = userMap['systemAccess'];

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
    } catch (e) {
      // Handle any errors that may occur during the query or data retrieval
      debugPrint('Error checking system access: $e');
      return null;
    }
  }
}
