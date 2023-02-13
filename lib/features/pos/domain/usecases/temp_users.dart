import 'package:single_machine_cashier_ui/features/pos/domain/repositories/user_repository.dart';

import '../entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class TempUsers {
  List<User> getTempUsers() {
    List<User> our_users = [];
    return [User(userName: 'ahmed'), User(userName: 'ahmed')];
  }
}
