import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/common/utils.dart';
import 'package:geekhub/model/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// @file   :   post_api
/// @author :   leetao
/// @date   :   2021/8/14 5:14 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

class PostApi {

  /// 发布普通帖子
  static Future<String> createPost(Post post) async{
      Map headers = await Utils.getHeaders();
      headers['content-type'] = 'application/x-www-form-urlencoded';
      headers['origin'] = 'https://www.geekhub.com';
      headers['referer'] = 'https://www.geekhub.com/posts/new';
      post.authenticityToken = await getAuthenticityToken('https://www.geekhub.com/posts/new');
      var body = post.toJson();
      var resp = await http.post(Uri.parse('https://www.geekhub.com/posts'),
          headers: headers,
          body: body);
      if (resp.statusCode != 302) {
        print(resp.statusCode);
        return null;
      }
      return resp.headers['location'];
  }

  static Future<String> getAuthenticityToken(String url) async {
    var headers = await Utils.getHeaders();
    var resp = await http.get(Uri.parse(url), headers: headers);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    var inputEle = doc.querySelector('#new_post > input[type=hidden]');
    return inputEle.attributes['value'];
  }
}