import 'dart:convert';

import 'package:test/test.dart';
import 'package:geekhub/api/post_api.dart';
import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/model/post_model.dart';
import 'package:geekhub/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// @file   :   post_api_test
/// @author :   leetao
/// @date   :   2021/8/14 8:26 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

void main() {
  test('createPost', () async {
    try {
      String sessionId = '_session_id=uXljLIO3cvVbFwFo9DqGLf4fs4QmlCHEKy%2BXMDvLhYZGgTO0CvidIr1CrRlkxkst7ATMTPQeHRECX9BcRan3y3NbCrPkE%2FtJLESS7jgy55wnOqoXQzYZH8S2OoHeVE4KkGfooJ7w92XHnFppGPxjfKq3VMhveOUgb8at75uRCZL6WF%2BI6%2FoMWh4sUBDnLKfZ8RJQDZBL5ZsinIPZFuzSbgYkoKILaihsFhw8PcTHzWGLZTumvtXHdp9lJ2IzQJAlhENbutqUGHvxRcdGgP8O7igmaQ0hdOHwOJuaYCCYfekFcctZZVyKuq3IgvqEQQ0DHRQEna%2FvwPt32e32djjuz9rxqaFE0r1jJNJqjnaQ4uMAS4o2YFfYhd02Qw4BJ1u%2FnCrLtSKzhMA5BSTVtvsodzN8ruC5PCpKu0L1fhyno%2FV3KNxeK%2FwiRYTuu1svJJQ%2FnpkqKNVKYfCQWzBKQ7TEqPliOr6h--hoaNSS5LiykQ5i6R--19qrzD8C9lcM0ZTpXx1AXw%3D%3D';
      User user = new User(sessionId: sessionId);
      SharedPreferences.setMockInitialValues(
          {'user': jsonEncode(user.toJson())});
      Post post = new Post(title: 'test by geekhub app',
          content: 'geekhub app 发帖测试',
          clubId: '20',
          shopId: '0',
          authenticityToken: 'KY-I3OJuuhGyFSXK-Oe3mY-hP_kHcCrB-KpHuXRSBW733GplON_iaBHIAPIDrLOvxS4FOdfAedepqZ6n1bkfTA');
      String url = await PostApi.createPost(post);
      expect(url != null, true);
    } catch(e) {
      expect(e is ApiException, true);
    }
  });
}