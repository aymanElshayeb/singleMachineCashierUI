import 'dart:convert';
import 'package:meta/meta.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../main.dart';
import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<User>> getUsers();
  Future<List<User>> addUsers(User user);
}

const CACHED_USERS = 'CACHED_USERS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl();

  @override
  Future<List<User>> getUsers() async {
    List<User> myUsers = [];
    return Future.value(myUsers);
  }

  @override
  Future<List<User>> addUsers(User user) {
    return Future.value([]);
  }
}
