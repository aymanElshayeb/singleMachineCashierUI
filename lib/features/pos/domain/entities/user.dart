import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class User extends Equatable {
  final String userName;

  int id;

  final String role;

  final String password;

  final String fullname;

  User(
      {this.id = 0,
      required this.userName,
      required this.role,
      required this.password,
      required this.fullname});

  factory User.fromJson(Map<String, dynamic> jsonMap) {
    return User(
        userName: jsonMap['userName'],
        role: jsonMap['role'],
        password: jsonMap['password'],
        fullname: jsonMap['fullname']);
  }
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'role': role,
      'password': password,
      'fullname': fullname
    };
  }

  @override
  List<Object?> get props => [userName, role, password, fullname];
}
