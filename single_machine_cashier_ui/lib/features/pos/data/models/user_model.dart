

import 'package:meta/meta.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';


class UserModel extends User {
  UserModel({
    @required String userName,
    @required int id,
    @required String role,
    @required password
  }) : super(userName: userName, id: id,role: role,password:password);

  //Question why not usual constructor
  factory UserModel.fromJson(Map<String, dynamic> jsonMap) {
    return UserModel(userName: jsonMap['userName'], id: jsonMap['id'],role:jsonMap['role'], password: jsonMap['jsonMap']);
  }
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'id': id,
      'role':role,
      'password':password
    };
  }
}
