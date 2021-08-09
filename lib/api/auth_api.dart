import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/common/utils.dart';
import 'package:geekhub/model/auth_model.dart';
import 'package:http/http.dart' as http;

import 'comment_api.dart';

class AuthApi {
  static Future<String> login(
      String user, String password, String captcha, AuthModel authModel) async {
    var body = {
      'user[password]': password,
      'user[login]': user,
      '_rucaptcha': captcha,
      'authenticity_token': authModel.token
    };
    var resp = await http.post(Uri.parse('https://www.geekhub.com/users/sign_in'),
        body: body, headers: {"user-agent": "GeekHub App By Leetao",'cookie':authModel.cookie});
    var respHeaders = resp.headers;
    if (respHeaders['location'] == 'https://www.geekhub.com/users/sign_in') {
      throw new AuthException();
    }
    return respHeaders['set-cookie'].split(";")[0];
  }

  /// 签到
  static Future<bool> checkIn() async{
    var headers = await Utils.getHeaders();
    String authenticityToken = await CommentApi.getCsrfToken('https://www.geekhub.com/checkins');
    print("checkIn headers:$headers");
    var body = {
      "_method": "post",
      "authenticity_token": authenticityToken
    };
    var resp = await http.post(Uri.parse('https://www.geekhub.com/checkins/start'),headers: headers,body: body);
    print("checkIn code:${resp.statusCode}");

    if (resp.statusCode == 302) {
      return true;
    }
    return false;
  }
}
