import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/common/utils.dart';
import 'package:geekhub/model/groups.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

/// @file   :   groups_api
/// @author :   leetao
/// @date   :   2021/8/8 9:51 上午
/// @email  :   leetao94@gmail.com
/// @desc   :   


class GroupsApi {
  /// 获取小组信息
  static Future<List<Groups>> getGroupListByUrl(String url) async {
    var headers = await Utils.getHeaders();
    var resp = await http.get(Uri.parse(url),headers: headers);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    Element feedDiv = doc.getElementById("home-feed-list");
    if (feedDiv.getElementsByTagName("article").length > 0) {
      return Utils.getGroupsByFishMode(doc);
    }
    return Utils.getGroupsByInfoMode(doc);
  }
}