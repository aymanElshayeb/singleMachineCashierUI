import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  /// Throws [CacheException] if no data is present
  Future<List<UserModel>> getUsers();
  Future<void> cacheUsers(UserModel triviaToCache);
}

const CACHED_USERS = 'CACHED_USERS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<UserModel>> getUsers() {
    final jsonString = sharedPreferences.getString(CACHED_USERS);

    if (jsonString != null) {
      final List<Map<String, dynamic>> jsonMap = json.decode(jsonString);
      List<UserModel> users;

      for (var user in jsonMap) {
        users.add(UserModel.fromJson(user));
      }
      return Future.value(users);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUsers(UserModel triviaToCache) {
    return sharedPreferences.setString(
      CACHED_USERS,
      json.encode(triviaToCache.toJson()),
    );
  }
}
