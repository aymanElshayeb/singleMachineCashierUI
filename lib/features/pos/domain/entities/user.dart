import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String userName;
  final int id;
  final String role;
  final String password;
  final String fullname;

  User(
      {@required this.userName,
      @required this.id,
      @required this.role,
      @required this.password,
      @required this.fullname})
      : super([userName, id, role, password, fullname]);

  factory User.fromJson(Map<String, dynamic> jsonMap) {
    return User(
        userName: jsonMap['userName'],
        id: jsonMap['id'],
        role: jsonMap['role'],
        password: jsonMap['password'],
        fullname: jsonMap['fullname']);
  }
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'id': id,
      'role': role,
      'password': password,
      'fullname': fullname
    };
  }
}
