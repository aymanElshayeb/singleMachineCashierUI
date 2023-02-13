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
}
