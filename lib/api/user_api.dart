import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/model/user.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;


class UserApi {
  static Future<User> getUserInfo(String session) async {
    var resp =
        await http.get(Uri.parse('https://www.geekhub.com'), headers: {"user-agent": "GeekHub App by Leetao",'cookie':session});
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    var userEle = doc.getElementById('sticky-sidebar');
    var userInfoEle = userEle.querySelector('div.p-3.box6.fix-box-border > div.flex.justify-between > div');
    var avatar = userInfoEle.querySelector('img').attributes['src'];
    var id = userInfoEle.getElementsByTagName('h4')[0].text.trim();
    var scoreInfoEle = userEle.querySelectorAll('div.mt-5>div.flex>div')[1];
    var score = scoreInfoEle.querySelectorAll('div')[0].text.trim();
    var messageCount = doc.querySelectorAll("div.flex-1.flex.items-center.justify-end > div.flex.items-center.ml-5>a>span")[1].text.trim();
    return User.fromJson({
        "id": id,
        "avatar": avatar,
        "gbit": score,
        "messageCount": int.parse(messageCount),
        "sessionId": resp.headers['set-cookie'].split(";")[0]
    });
  }

}