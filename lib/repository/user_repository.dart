import 'dart:convert';

import 'package:geekhub/api/user_api.dart';
import 'package:geekhub/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  // User _user;

  /// 从缓存中获取用户信息
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user")) {
      return User.fromJson(jsonDecode(prefs.getString("user")));
    }
    return null;
  }

  /// 将用户信息设置到缓存中
  Future<void> setUser(User user) async {
    /// 根据 session 获取个人主页信息
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("session", user.sessionId);
    print('user session:${user.sessionId}');
    prefs.setString("user", jsonEncode(user.toJson()));
  }

  /// 刷新用户信息
  Future<User> refreshUser(session) async {
    User _refreshUser = await UserApi.getUserInfo(session);
    await setUser(_refreshUser);
    return _refreshUser;
  }
}
