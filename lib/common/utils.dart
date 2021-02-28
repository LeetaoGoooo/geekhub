import 'package:geekhub/repository/user_repository.dart';

class Utils {
    static Future<Map> getHeaders() async{
    var user = await new UserRepository().getUser();
    var headers = {"user-agent": "GeekHub App by Leetao"};
    if (user != null) {
      headers['cookie'] = user.sessionId;
    }
    return headers;
  }
}