import 'package:flutter/foundation.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/repositories/auth_repository.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class OfflineAuthRepository implements BaseAuthRepository {
  final FlutterSecureStorage secureStorage;
  final String apiUrl = 'http://localhost:3005/auth';

  OfflineAuthRepository({required this.secureStorage});
  @override
  EitherUser<User> emailSignInUser(String email, String password) async{
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'system': 'POS',
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String token = data['token'];

        // Store the token securely
        saveToken(token);
        User currentUser = User.fromJson(data['user']);
        return right(currentUser); // No error
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String error = data['error'];
        return left(error); // Return the error message
      }
    } catch (error) {
      debugPrint('error message: $error');
      return left(
          'Failed to connect to the server, error message : $error'); // Generic error message
    }
  }

  @override
  EitherUser<User> googleSignInUser() {
    // TODO: implement googleSignInUser
    throw UnimplementedError();
  }

  @override
  EitherUser<String> signOutUser() async{
    try {
      deleteToken();
      return right('signed out successfully');
    } catch (e) {
      return left(e.toString());
    }
  }
    Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'token', value: token);
  }

  Future<String?> readToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: 'token');
  }
}
