import 'dart:convert';

import 'package:geekhub/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  User _user;

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user")) {
      return User.fromJson(jsonDecode(prefs.getString("user")));
    }
    return null;
  }

  Future<void> setUser(User user) async {
    /// 根据 session 获取个人主页信息
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("session", user.sessionId);
    print('user session:${user.sessionId}');
    prefs.setString("user", jsonEncode(user.toJson()));
  }
}
