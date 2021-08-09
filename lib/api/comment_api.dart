import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/common/utils.dart';
import 'package:geekhub/model/comment_action.dart';
import 'package:geekhub/model/comment_form.dart';
import 'package:geekhub/repository/user_repository.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class CommentApi {
  static Future<bool> makeComment(
      CommentAction commentAction, CommentForm commentForm) async {
    var body = {
      "authenticity_token": commentForm.authenticityToken,
      "comment[target_type]": commentForm.targetType,
      "comment[target_id]": commentForm.targetId,
      "comment[counter_base]": commentForm.counterBase,
      "comment[reply_to_id]": commentAction.replyToId,
      "comment[ua]": "Geekhub App By Leetao",
      "comment[content]": commentAction.content
    };
    print(body);
    // print(authModel.cookie);
    var user = await new UserRepository().getUser();
    // print('https://www.geekhub.com$url');
    print(user.sessionId);
    var resp = await http.post(Uri.parse('https://www.geekhub.com/comments'),
        headers: {
          "user-agent": "GeekHub App by Leetao",
          'cookie': user.sessionId.split(";")[0],
          'referer': 'https://www.geekhub.com/users/sign_in',
          'accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
          'accept-encoding': 'gzip, deflate, br',
          'accept-language': 'zh-CN,zh;q=0.9',
        },
        body: body);
    if (resp.statusCode != 200) {
      print(resp.statusCode);
      return false;
    }
    print(resp.body);
    return true;
  }

  static Future<CommentForm> getCommentForm(url) async {
    var headers = await Utils.getHeaders();
    var resp = await http.get(Uri.parse(url), headers: headers);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    var form = doc.getElementById('comment-box-form');

    var input = form.querySelector('input');
    var token = input.attributes['value'];
    var targetType =
        doc.getElementById("comment_target_type").attributes['value'];
    var targetId = doc.getElementById("comment_target_id").attributes['value'];
    var counterBase =
        doc.getElementById('comment_counter_base').attributes['value'];

    return new CommentForm(
        authenticityToken: token,
        targetType: targetType,
        targetId: targetId,
        counterBase: counterBase);
  }
}
