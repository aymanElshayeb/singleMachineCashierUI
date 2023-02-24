import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/user.dart';
import '../../../../core/error/exceptions.dart';

abstract class UserLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<User>> getUsers();
  Future<void> cacheUsers(User triviaToCache);
  Future<List<User>> addUsers(User user);
}

const CACHED_USERS = 'CACHED_USERS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  List<Map<String, Object>> jsonString = [
    {
      "userName": "ahmed",
      "id": 1,
      "role": "ADMIN",
      "password": "po",
      "fullname": "ahmed mostafa"
    },
    {
      "userName": "yasser",
      "id": 2,
      "role": "Cashier",
      "password": "qwertyuiop",
      "fullname": "yasser mohamed"
    },
  ];

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<User>> getUsers() {
    // final jsonString = sharedPreferences.getString(CACHED_USERS);

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = jsonString;
      List<User> users = [];
      for (var user in jsonMap) {
        users.add(User.fromJson(user));
      }
      return Future.value(users);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUsers(User triviaToCache) {
    return sharedPreferences.setString(
      CACHED_USERS,
      json.encode(triviaToCache.toJson()),
    );
  }

  @override
  Future<List<User>> addUsers(User user) {
    jsonString.add(user.toJson());

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = jsonString;
      List<User> users = [];
      for (var user in jsonMap) {
        users.add(User.fromJson(user));
      }
      return Future.value(users);
    } else {
      throw CacheException();
    }
  }
}
